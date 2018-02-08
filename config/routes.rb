Rails.application.routes.draw do
  resources :categories
  root to: 'visitors#index'
end
