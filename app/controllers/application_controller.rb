class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def self.expose(name, value = nil, decorate: false, guess_value: true, scope: :all)
    Exposed.new(name, value, guess_value: guess_value, scope: scope).tap do |e|
      define_method name do
        e.call(self)
      end
      helper_method name
      decorate(name) if decorate
    end
  end

  def self.decorate(name)
    define_method "decorated_#{name}" do
      vname = "@decorated_#{name}"
      instance_variable_get(vname) || instance_variable_set(vname, send(name).decorate)
    end
  end
end
