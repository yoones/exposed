class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  extend Exposer
end
