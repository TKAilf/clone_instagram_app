Rails.application.routes.draw do
  get '/login', to: "sessions#new"
  resources :users
  
  root 'sessions#new'
end
