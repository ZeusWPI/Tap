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

  resources :users, only: [:show, :update] do
    resources :orders, only: [:new, :create, :destroy]
    member do
      get 'quickpay'               => 'users#quickpay'
      get 'dagschotel/edit'        => 'users#edit_dagschotel', as: 'edit_dagschotel'
    end
  end

  resources :products, only: [:create, :index, :edit, :update] do
    resources :barcodes, only: :create
    collection do
      get 'barcode' => 'products#barcode', as: :barcode
      post 'barcode' => 'products#load_barcode', as: :load_barcode
    end
  end

  resources :barcodes, only: [:show, :index, :destroy]

  get 'overview' => 'orders#overview', as: "orders"

  namespace :guest do
    resources :orders, only: [:new, :create]
  end
end
