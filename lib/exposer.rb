
module Exposer
  def expose(name, value = nil, decorate: false, guess_value: true, scope: :all)
    Exposed.new(name, value, guess_value: guess_value, scope: scope).tap do |e|
      define_method name do
        e.call(self)
      end
      helper_method name
      decorate(name) if decorate
    end
  end

  def decorate(name)
    mname = "decorated_#{name}"
    vname = "@#{mname}"
    define_method mname do
      instance_variable_get(vname) || instance_variable_set(vname, send(name).decorate)
    end
    helper_method mname
  end

  class Exposed
    def initialize(name, value = nil, guess_value: true, scope: :all)
      @name = name
      @guess_value = guess_value
      @scope = scope
      @initial_value = value
    end

    def call(instance)
      @instance = instance
      v = if initial_value.nil? && guess_value
            (name.to_s == pluralized_name ? :collection : :record)
          else
            initial_value
          end
      reinterpret_value(v)
    end

    private

    attr_reader :name, :value, :instance, :initial_value, :guess_value, :scope

    def singularized_name
      @singularized_name ||= name.to_s.singularize
    end

    def pluralized_name
      @pluralized_name ||= name.to_s.pluralize
    end

    def klass
      @klass ||= singularized_name.capitalize.constantize
    end

    def reinterpret_value(v)
      if v.respond_to?(:call)
        v.call
      elsif v == :collection
        infer_collection
      elsif v == :record
        infer_record
      else
        v
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

end
