class Exposed
  attr_accessor :name, :value

  def initialize(name, value = nil, guess_value: true, scope: :all)
    @name = name
    @decorated_name = "decorated_#{@name}"
    @decorate = decorate
    @guess_value = guess_value
    @scope = scope
    @value = value
  end

  def call(instance)
    @instance = instance
    reinterpret_value
    self
  end

  private

  attr_reader :instance, :decorate, :guess_value, :scope

  def singularized_name
    @singularized_name ||= name.to_s.singularize
  end

  def pluralized_name
    @pluralized_name ||= name.to_s.pluralize
  end

  def klass
    @klass ||= singularized_name.capitalize.constantize
  end

  def reinterpret_value
    @value = (name.to_s == pluralized_name ? :collection : :record) if value.nil? && guess_value
    @value = if value.respond_to?(:call)
      value.call
    elsif value == :collection
      infer_collection
    elsif value == :record
      infer_record
    else
      value
    end
  end

  def infer_collection
    klass.send(@scope)
  end

  def infer_record
    source = if instance.respond_to?(pluralized_name)
               ->{ instance.send(pluralized_name) }
             else
               ->{ klass.send(scope) }
             end
    if instance.respond_to?(:params) && instance.params.has_key?(:id)
      source.call.find(instance.params[:id])
    else
      source.call.new(params)
    end
  end

  def params
    @params ||=
      if instance.respond_to?("#{singularized_name}_params")
        instance.send("#{singularized_name}_params")
      else
        {}
      end
  end
end
