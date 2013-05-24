Bento::Application.routes.draw do

  # ============================================================
  # USER ROUTES
  # ============================================================
  delete "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"
  get "signup" => "registrations#new", as: "signup"
  get "profile" => "registrations#edit", as: "profile"
  post "profile" => "registrations#update", as: "update_profile"
  get "paswords/:token/edit" => "passwords#edit", as: "change_password"
  resource :password, only: [:new, :create, :edit, :update]
  resources :registrations, except: [:index, :show, :destroy]
  resources :sessions
  
  # ============================================================
  # STRIPE ROUTES
  # ============================================================
  get '/stripe/callback' => 'stripe#callback'

  # ============================================================
  # ADMIN ROUTES
  # ============================================================
  scope module: 'admin', path: 'adm1nistr8tion', as: 'admin' do
    root to: 'dashboard#show', as: :dashboard
    get 'audit', to: 'audit_trails#index', as: 'audit'
    resource :stock, only: [:show, :update], path: 'stocks', as: 'stocks'
    resources :articles
    resources :clients, only: [:index, :show] do
      get 'export', on: :collection
    end
    resources :coupons, except: :show
    resources :pages
    resources :taxes
    scope "/shipping" do
      root to: 'shipping_countries#index', as: :shipping
      resources :shipping_countries, except: [:index, :show]
    end
    
    resources :collections do
      member do
        post "sort_products"
        post "add_products"
        post "remove_products"
      end
    end

    resources :resellers, only: [:index, :show] do
      member do
        post :approve
        post :disapprove
      end
    end
    
    resources :products do
      resource :options, only: [:edit, :update], as: :options
      resources :variants, only: [:destroy]
      collection do
        put :feature
      end
      resources :pictures do
        collection do
          post :sort
        end
      end
    end

    resources :product_reviews, only: [:index, :show] do
      member do
        post :approve
        post :disapprove
      end
    end

    resource :settings, only: [:show, :update] do
      delete :remove_logo
    end
    
    resource :reports do
      collection do
        get "sales"
        get "monthly_sales"
        get "orders"
      end
    end

    resources :users, except: [:show, :edit, :update] do
      member do
        post :activate
        post :deactivate
      end
    end

    resources :orders, only: [:index, :show, :edit, :update] do
      put "print", on: :collection
      member do
        post "mark_as_shipped"
        post "cancel"
      end
    end
  end

  # ============================================================
  # RESELLER ROUTES
  # ============================================================
  scope module: 'reseller', path: 'reseller', as: 'reseller' do
    root to: 'dashboard#show', as: :dashboard
  end  

  # ============================================================
  # PUBLIC ROUTES
  # ============================================================
  get "application/users" # used for dynamic caching only
  
  scope "/blog" do
    get "/", controller: 'articles', action: 'index', as: 'blog'
    get "/:slug" => "articles#show", as: 'article'
    get "/tag/:tag" => "articles#index", as: 'tag'
  end

  resource :cart, except: [:new, :create, :edit] do
    member do
      post :apply_coupon
      post :remove_coupon
      get :checkout
      post :continue
    end
    resources :line_items
  end
  resources :line_items, only: [:create, :update]
  
  resources :orders, only: [:index, :new, :create, :show]
  resources :tags, only: :index
  resources :categories, only: :index
  resources :suppliers, only: :index
  resources :product_reviews, only: :create
  resources :products, only: [:index, :show] do
    get :search, on: :collection
  end
  resources :shippings, only: [] do
    post :search, on: :collection
  end
  get "/category/:category", to: "products#index", as: 'category'
  get "/collection/:slug", to: "collections#show", as: 'collection'
  get "become_reseller", to: "pages#become_reseller", as: "become_reseller"
  resource :reseller_request, only: :create
  
  get "/:slug" => 'pages#show', as: 'page'
  
  root :to => 'pages#home'
end