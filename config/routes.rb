Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    unauthenticated :user do
      root to: 'devise/sessions#new'
    end
    authenticated :user do
      root to: 'orders#overview',     constraints: UserHomepageConstraint.new(true), as: 'koelkast_root'
      root to: 'users#show',          constraints: UserHomepageConstraint.new(false), as: 'user_root'
    end
  end

  resources :users do
    resources :orders
    get 'quickpay' => 'orders#quickpay'
    get 'dagschotel/:product_id' => 'users#dagschotel', as: "dagschotel"
  end

  resources :products do
    collection do
      get  'stock' => 'products#stock', as: 'stock'
      post 'stock' => 'products#update_stock', as: 'update_stock'
    end
  end

  get 'admins' => 'admins#schulden', as: "admins_schulden"
  get 'overview' => 'orders#overview', as: "orders"
end
