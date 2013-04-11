Bento::Application.routes.draw do
  
  resources :orders


  # ============================================================
  # USER ROUTES
  # ============================================================
  delete "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"
  get "signup" => "registrations#new", as: "signup"
  get "profile" => "registrations#edit", as: "profile"
  post "profile" => "registrations#update", as: "update_profile"
  get "paswords/:token/edit" => "passwords#edit", as: "change_password"
  resources :passwords, only: [:new, :create, :edit]
  resources :registrations, except: [:index, :show, :destroy]
  resources :sessions

  # ============================================================
  # ADMIN ROUTES
  # ============================================================
  scope module: 'admin', path: 'adm1nistr8tion', as: 'admin' do
    root to: 'dashboard#show', as: :dashboard
    get 'audit', to: 'audit_trails#index', as: 'audit'
    get 'stocks', to: "stocks#index", as: :stocks
    resources :stocks, only: :index do 
      collection do
        put :update_multiple
      end
    end
    
    resources :articles
    resources :clients, only: [:index, :show]
    resources :resellers, only: [:index, :show] do
      member do
        post :approve
        post :disapprove
      end
    end
    resources :coupons, except: :show
    resources :pages
    
    resources :products do
      collection do
        put :feature
      end
    end

    resource :settings, only: [:edit, :update]
    match "settings" => "settings#edit"
    
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
      member do
        post "mark_as_shipped"
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
    resources :line_items
  end
  resources :line_items, only: [:create, :update]
    
  resources :tags, only: :index
  resources :categories, only: :index
  resources :products, only: [:index, :show]
  get "/category/:category", to: "products#index", as: 'category'
  get "become_reseller", to: "pages#become_reseller", as: "become_reseller"
  resource :reseller_request, only: :create
  
  get "/:slug" => 'pages#show', as: 'page'
  
  root :to => 'pages#home'
end