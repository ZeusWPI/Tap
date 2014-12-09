Rails.application.routes.draw do

  root "orders#overview"

  devise_for :users

  resources :users do
    resources :orders, only: [:new, :create, :index]
  end

  resources :products
end
