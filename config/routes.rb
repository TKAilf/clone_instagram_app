Rails.application.routes.draw do
  get 'static_pages/home', to: "static_pages#home"
  get '/login', to: "sessions#new"
  get  '/signup',  to: 'users#new'
  post '/signup', to: "users#create"
  resources :users
  
  root 'sessions#new'
end
