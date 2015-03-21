Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "callbacks",
    sessions:           "sessions"
  }

  devise_scope :user do
    unauthenticated :user do
      root to: 'sessions#new'
    end

    authenticated :user, ->(u) { u.koelkast? } do
        root to: 'orders#overview', as: :koelkast_root
    end

    authenticated :user, ->(u) { !u.koelkast? } do
        root to: 'users#show', as: :user_root
    end
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :users do
    resources :orders
    get 'quickpay'               => 'orders#quickpay'
    get 'dagschotel/edit'        => 'users#edit_dagschotel', as: 'edit_dagschotel'
    get 'dagschotel/:product_id' => 'users#update_dagschotel', as: 'dagschotel'
  end

  resources :user_avatar

  resources :products do
    collection do
      get  'stock' => 'products#stock', as: 'stock'
      post 'stock' => 'products#update_stock', as: 'update_stock'
    end
  end

  get 'admins' => 'admins#schulden', as: "admins_schulden"
  get 'overview' => 'orders#overview', as: "orders"
end
