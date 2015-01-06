Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: 'root#root'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: 'unauth_root'
    end
  end

  resources :users do
    resources :orders, only: [:new, :create, :index]
    get 'quickpay' => 'orders#quickpay'
    get 'dagschotel/:product_id' => 'users#dagschotel', as: "dagschotel"
  end

  resources :products
  get 'admins' => 'admins#schulden', as: "admins_schulden"
  get 'overview' => 'orders#overview', as: "orders"
end
