require 'sidekiq/web'

Rails.application.routes.draw do
  root 'messages#index'
  resources :messages, only: [:index, :create]

  mount Sidekiq::Web => '/sidekiq'
end
