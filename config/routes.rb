Ssg::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # Assets redirect
  get '/img/:name', to: redirect {|params, req| "/assets/#{params[:name]}.#{params[:format]}" }

  if Rails.env.development?
    mount UserMailer::Preview => 'mail_view'
  end
  
  resources  :users do
    collection do
      get   :fb_login
      post  :ssg_login
      post  :ssg_admin_login
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
    end
    collection do 
      get   :more
    end
  end

  resources :images, :only => [:create, :destroy]

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

  resources :cities do
    collection do
      get 'zoom'
    end
  end

  # Static redirect
  get '/faq'      => 'documents#faq'
  get '/privacy'  => 'documents#privacy'
  get '/help'     => 'documents#help'
  get '/contact'  => 'documents#contact' 
  get '/terms'    => 'documents#terms' 
  get '/learn'    => 'documents#learn'

  # change locale
  get '/locale_change' => 'application#change_locale'

  # SSG Admin
  get '/ssg_admin/login' => 'ssg_admin#login'
  get '/ssg_admin/'      => 'ssg_admin/cities#index'



  get '/auth/facebook/callback' => 'users#fb_login'


  root :to => 'issues#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
