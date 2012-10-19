class RegistrationsController <  Devise::RegistrationsController
  before_filter :is_user_exist? ,:only=>[:create]
  before_filter :redirect_to_initial_page_if_platform_is_not_configured_yet ,:only => [:new]
  #after_filter :get_ip_and_country ,:only=>[:create]


  def create
    #build_resource
    #if resource.save
    #  if resource.active_for_authentication?
    #    set_flash_message :notice, :signed_up if is_navigational_format?
    #    sign_in(resource_name, resource)
    #    respond_with resource, :location => after_sign_up_path_for(resource)
    #  else
    #    set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
    #    expire_session_data_after_sign_in!
    #    respond_with resource, :location => after_inactive_sign_up_path_for(resource)
    #  end
    #else
    #  clean_up_passwords resource
    #  respond_with resource
    #end

    @user = User.new(params[:user])
    @user.fetch_ip_and_country(request)
    if @user.save
      logger.info "++++++++++++++++++++++++++++++++++++++++++++++++++#{@user.inspect}"
      redirect_to login_path , :notice => "'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'"
    else
       redirect_to new_user_registration_path , :notice => "Enter Valid Email"
    end

  end

  private

  def is_user_exist?
    #if verify_recaptcha
      user = User.where(:email=>params[:user][:email]).to_a.first
      if user.present?
        if user.status.downcase == "active"
          redirect_to new_user_registration_path ,:notice => "User Already present with this Email Id"
        end

        if user.status.downcase == "new"
          redirect_to user_exists_homes_path(:id =>user)
        end
      end
    #else
    #  redirect_to new_user_registration_path ,:notice => "ReCapta was not correct"
    #end
  end

  def get_ip_and_country
    logger.info "++++++++++++++++++++++++++++++++++++++++++++++++++#{resource.inspect}"
    resource.fetch_ip_and_country(request)
    resource.save!
  end
end
