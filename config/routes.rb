Winnitude::Application.routes.draw do

  constraints(:subdomain => ADMIN_SUBDOMAIN) do
    scope :module => "admin" do
      resources :global_admins do
        collection do
          get "set_platform_page"
          post "set_platform"
          get :edit_ga_general_settings
          put :update_ga_general_settings
          get :edit_ga_links
          put :update_ga_links
          get :edit_ga_default_billing_profile
          put :update_ga_default_billing_profile
          get :edit_ga_paas_billing_profile
          put :update_ga_paas_billing_profile
          get :edit_platform_terms
          put :update_platform_terms
          get :edit_ga_projects_commissions
          put :update_ga_projects_commissions
          get :edit_ga_projects_settings
          put :update_ga_projects_settings
        end
      end
      resources :products
      resources :countries ,:except => [:new, :create, :destroy]
      resources :currencies ,:except => [:new, :create, :destroy]
      resources :languages  ,:except => [:new, :create, :destroy]
    end
  end
  as :user do
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
    match '/user/management'   =>'users#user_management',:via => :get
    match '/user/information/:id'   =>'users#show_user_to_local_admin',:via => :get ,:as=>:show_user_to_local_admin
    match '/user/edit/:id'   =>'users#edit_user_info',:via => :get ,:as=>:edit_user_info
    match '/user/update/:id'   =>'users#update_user_info',:via => :post ,:as=>:update_user_info
    match '/user/suspend/:id'   =>'users#suspend_user',:via => :get    ,:as=>:suspend_user

  end


  devise_for :users, :scope => "user",
             :controllers => {:omniauth_callbacks => "omniauth_callbacks" ,
                              :sessions => "sessions" ,
                              :confirmations => 'confirmations',
                              :passwords => 'passwords',
                              :registrations => 'registrations'
             }   do
    get "/login", :to => "sessions#new"
    get "/logout", :to => "sessions#destroy"

  end
  resource :homes do
    collection do
      get "platform_not_configured"
    end

  end

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
  root :to => 'homes#index'

  resources :people do
#    member do
#
#    end
    collection do
      get 'provider_terms_of_service'
      put 'update_provider_terms_of_service'
    end
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
