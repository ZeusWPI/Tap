Rails.application.routes.draw do
  # Includes devise_for method for routes.
  # This method is responsible to generate all needed routes for devise, based on what modules you have defined in your model.
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  # Authentication
  # Using "devise"
  devise_scope :user do

    # Sign in/auth endpoints
    get "/sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
    get "/sign_in", to: "landing#token_sign_in"

    # Root for unauthenticated users
    unauthenticated :user do
      root to: "landing#index"
    end

    # Root for authenticated koelkast
    authenticated :user, ->(u) { u.koelkast? } do
      root to: "orders#overview", as: :koelkast_root
    end

    # Root for authenticated users
    authenticated :user, ->(u) { !u.koelkast? } do
      root to: "users#show", as: :user_root
    end
  end

  # /users/...
  resources :users, only: [:show, :update] do
    resources :orders, only: [:index, :new, :create, :destroy] do
      get :new_products, on: :collection
      post "/new" => "orders#new_update", on: :collection
    end

    member do
      # Dagschotel
      get "dagschotel/edit" => "users#edit_dagschotel"
      post "dagschotel/order" => "users#order_dagschotel"

      # Legacy endpoints, required for Tappb
      get "quickpay" => "users#order_dagschotel"

      # Change the user's API key.
      post :reset_key
    end
  end

  # /products/...
  resources :products, only: [:index, :create, :new, :edit, :update] do
    resources :barcodes, only: :create
  end

  # /barcodes/...
  resources :barcodes, only: [:index, :show, :create, :new, :destroy]

  # Koelkast overview page
  get "overview" => "orders#overview", as: "orders"

  # Guest endpoints
  namespace :guest do
    resources :orders, only: [:new, :create]
  end

  # Page for changing the theme of the user's browser
  get '/theme', to: "application#set_theme_page"
  # Set the theme of the user's browser
  post '/theme', to: "application#set_theme", as: "set_theme"
end
