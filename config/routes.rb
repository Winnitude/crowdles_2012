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
          get :edit_la_paas_billing_profile
          get :new_user
          post :create_user
          get :all_users
        end
      end
      resources :products
      resources :countries ,:except => [:new, :create, :destroy] do
        get :autocomplete_service_country_country_english_name, :on => :collection
      end
      resources :currencies ,:except => [:new, :create, :destroy] do

      end
      resources :languages  ,:except => [:new, :create, :destroy]
      resources :local_admins ,:except => [:new, :create, :destroy] do
        member do
          get :edit_la_general_settings
          put :update_la_general_settings
          get :edit_la_paas_billing_profile
          put :update_la_paas_billing_profile
          get :edit_la_terms
          put :update_la_terms
          get :edit_la_organization_details
          put :update_la_organization_details
        end
      end
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
    #get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'

  end
  resource :homes do
    collection do
      get "platform_not_configured"
      get "user_exists"
      post "send_verification_mail"
    end

  end

  resources :user_registrations , :only =>[] do
    post :finalize_register ,:on => :collection
    post :validate_account , :on => :collection
    post "create_new_user" , :on => :collection
    post "connect_fb_and_crowdles" , :on => :collection
    put "update_password" , :on => :collection
  end

  resources :profiles , :only =>[] do
    member do
    end
    collection do
      get :edit_address
      put :update_address
      get :edit_links
      put :update_links
      get :settings
      put :update_settings
      get :change_email
      put :update_email
    end
  end

  resources :users , :only =>[] do
    member do
      get :edit_address
      put :update_address
      get :edit_links
      put :update_links
      get :settings
      put :update_settings
      get :change_email
      put :update_email
      get :terms_of_use
      get :billing_profile
      put :update_billing_profile
    end
    collection do

    end
  end

  match 'register'   =>'user_registrations#register',:via => :get    ,:as=>:register
  match 'confirm_facebook'   =>'user_registrations#confirm_facebook',:via => :get   ,:as=>:confirm_facebook
  match 'confirm'=>'user_registrations#final_confirmation',:via => :get   ,:as=>:confirm
  match 'set_password'=>'user_registrations#set_password',:via => :get   ,:as=>:set_password
  match 'set_platform/:id'=>'admin_groups#new_platform',:via => :get   ,:as=>:set_platform


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

  resources :adaptive_payments,:only => [] do
    collection do
      get 'getStatus'
      post 'verified_status'
      get "details"
      get "error"
    end
  end

  resources :admin_groups do
   get :get_product_details, :on => :collection
   post :create_platform, :on => :collection

  end

  resources :plans ,:only => [:index] do

  end


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  resources :htmls , :only =>[] do
    collection do
      get :user_profile
      get :user_ideas
      get :user_sign_in
      get :user_links
      get :set_account_name_area
      get :completed
      get :billing_payment
      get :_user_act_as_admin_group_links
      get :upgrade
      get :downgrade
      get :cancelPlan
    end
  end
end
