Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "callbacks",
    sessions: "sessions"
  }

  devise_scope :user do
    unauthenticated :user do
      root to: 'welcome#index'
    end

    authenticated :user, ->(u) { u.koelkast? } do
        root to: 'orders#overview', as: :koelkast_root
    end

    authenticated :user, ->(u) { !u.koelkast? } do
        root to: 'users#show', as: :user_root
    end
  end

  resources :users do
    resources :orders
    get 'quickpay'               => 'orders#quickpay'
    get 'dagschotel/edit'        => 'users#edit_dagschotel', as: 'edit_dagschotel'
    get 'dagschotel/:product_id' => 'users#update_dagschotel', as: 'dagschotel'
  end

  resources :products
  resources :stocks

  get 'overview' => 'orders#overview', as: "orders"
end
