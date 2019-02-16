Rails.application.routes.draw do
  root to: 'home#index'
  get 'about' => 'home#index'
  get 'contact' => 'home#index'
  
  namespace :api, fomrmat: 'json' do
    resources :tasks, only: [:index, :crete, :update]
  end
end