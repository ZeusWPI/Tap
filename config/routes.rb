Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    unauthenticated :user do
      root to: 'welcome#index'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :barcodes, only: :index
      resources :orders,   only: :create
      resources :products, only: :index
      resources :users,    only: :index
    end
  end

  resource :user,    only: :show
  resources :orders, only: [:create, :index]

  namespace :stats do
    get :contributions
  end

  root to: 'react#index', as: 'user_root'
  get '/*path', to: 'react#index'
end
