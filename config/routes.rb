Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    unauthenticated :user do
      root to: 'welcome#index'
    end

    root to: 'users#show', as: :user_root
  end

  namespace :api do
    namespace :v1 do
      resources :barcodes, only: :index
      resources :orders,   only: :create
      resources :products, only: :index
      resources :users,    only: :index
    end
  end

  resources :users, only: [:show, :update] do
    resources :orders, only: [:new, :create, :destroy]
  end

  resources :products, only: [:new, :create, :index, :edit, :update] do
    resources :barcodes, only: :create
  end

  resources :barcodes, only: [:show, :index, :destroy]
end
