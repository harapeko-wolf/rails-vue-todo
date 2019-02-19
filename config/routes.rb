Rails.application.routes.draw do
  root to: 'home#index'
  get 'about' => 'home#index'
  get 'contact' => 'home#index'
  
  namespace :api, format: 'json' do
    resources :tasks, only: [:index, :create, :update]
  end
end