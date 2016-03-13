Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    get 'sign_in', to: 'welcome#token_sign_in'
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

  resources :users, only: [:show, :update, :index] do
    resources :orders,      only: [:new, :create, :destroy]
    resources :dagschotels, only: [:edit, :update, :destroy]
  end

  resources :products, only: [:new, :create, :index, :edit, :update] do
    resources :barcodes, only: :create
  end

  resources :barcodes, only: [:show, :index, :destroy] do
    post 'barcode' => 'products#load_barcode', as: :load_barcode, on: :collection
  end
end
