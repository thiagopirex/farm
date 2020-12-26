Rails.application.routes.draw do

  #get 'sessions/new'
  resources :sessions
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'


  resources :usuarios
  resources :propriedades
  resources :areas
  resources :analises
  resources :aguas
  resources :usos
  resources :acaos
  resources :malha_aguas
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'home#index'

  
end
