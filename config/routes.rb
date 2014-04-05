Ssg::Application.routes.draw do
  root :to => 'issues#index'
  
  resources  :users do
    collection do
      get   :fb_login
      post  :ssg_login
      post  :ssg_admin_login
      post  :admin_login
      post  :signup
      get   :login
      get   :verify
      get   :forgot_password
      get   :reset_password
      post  :activate_password
      post  :forgot_password_submit
    end
    member do
      get :logout
      get :follow
      get :index
      post :settings
    end
  end
  
  resources  :issues do 
    member do
      post  :vote
      post  :unvote
      get   :follow
      post  :change_status
      post  :attach_images
    end
    collection do 
      get   :more
    end
  end

  resources :images, :only => [:create, :destroy, :update]

  resources :comments, :only => [:create, :destroy]
  resources  :areas

  namespace :ssg_admin do
    resources :cities, :only => [:index, :destroy] do
      collection do
        post :create_or_edit
      end
    end

    resources :issues, :only => [:index, :update, :edit, :destroy] do
    end

    resources :categories, :only => [:index, :destroy] do
      collection do
        post :create_or_edit
      end
    end

    resources :users, :only => [:index, :destroy, :edit, :update, :new] do
      collection do
        post :create
      end
    end
  end


  namespace :admin do
    resources :issues
    resource :city
  end

  resources :cities do
    collection do
      get 'zoom'
    end
  end

  # Assets redirect
  get '/img/:name', to: redirect {|params, req| "/assets/#{params[:name]}.#{params[:format]}" }
  get '/images/:name', to: redirect {|params, req| "/assets/#{params[:name]}.#{params[:format]}" }

  # Static redirect
  get '/faq'      => 'documents#faq'
  get '/privacy'  => 'documents#privacy'
  get '/help'     => 'documents#help'
  get '/contact'  => 'documents#contact' 
  post '/contact_message'  => 'documents#contact_message' 
  get '/terms'    => 'documents#terms' 
  get '/learn'    => 'documents#learn'
  get '/reports'  => 'documents#reports'

  # change locale
  get '/locale_change' => 'application#change_locale'

  # SSG Admin
  get '/ssg_admin/login' => 'ssg_admin#login'
  get '/ssg_admin/'      => 'ssg_admin/issues#index'
  # City Admin
  get '/admin/login' => 'admin#login'
  get '/admin/'      => 'admin/issues#index'

  # twitter
  get '/auth/twitter/callback', to: 'users#twitter_create', as: 'callback'
  get '/auth/failure', to: 'users#auth_error', as: 'failure'
  get '/auth/facebook/callback' => 'users#fb_login', as: 'fb_callback'
end
