Rails.application.routes.draw do

  resources :propriedades
  resources :areas
  #resources :analises
  resources :aguas
  #resources :usos
  #resources :acaos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'home#index'

  
end
