Rails.application.routes.draw do
  get 'static_pages/home', to: "static_pages#home"
  get '/login',  to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  get '/signup',  to: 'users#new'
  post '/signup', to: "users#create"
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only:[:new,:create,:update,:edit]
  resources :microposts,          only: [:create, :destroy]
  
  root 'sessions#new'
end
