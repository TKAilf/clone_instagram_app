Rails.application.routes.draw do
  get 'static_pages/home', to: "static_pages#home"
  get '/login', to: "sessions#new"
  resources :users
  
  root 'sessions#new'
end
