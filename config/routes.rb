Rails.application.routes.draw do

  devise_for :users
  root 'homes#index'
  get 'saml/init'
  post 'saml/consume'

  resources :homes

end
