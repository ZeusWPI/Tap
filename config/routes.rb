Rails.application.routes.draw do

  root "orders#index"

  devise_for :users

  resources :users do
    resources :orders, only: [:new, :create, :index] do
    end
    get 'quickpay' => 'orders#quickpay'
    get 'dagschotel/:product_id' => 'users#dagschotel', as: "dagschotel"
  end

  resources :products
  get 'admins' => 'admins#schulden', as: "admins_schulden"
end
