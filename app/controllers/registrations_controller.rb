class RegistrationsController <  Devise::RegistrationsController
  before_filter :redirect_if_already_exist ,:only=>[:create]
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

    resource = User.new(params[:user])
    if resource.save
      logger.info "++++++++++++++++++++++++++++++++++++++++++++++++++#{resource.inspect}"
      resource.fetch_ip_and_country(request)
      resource.save
      logger.info "++++++++++++++++++++++++++++++++++++++++++++++++++#{resource.inspect}"
      redirect_to login_path , :notice => "'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'"
    end

  end

  private

  def redirect_if_already_exist
    #render :text=>"dsdgdsg"
    check_user = User.where(:email=>params[:user][:email]).to_a.first
    if !check_user.nil?
      if !check_user.confirmation_token.nil?
        redirect_to :controller => 'homes', :action => 'show_error_msg', :id =>check_user.id
      end
    end
  end

  def get_ip_and_country
    logger.info "++++++++++++++++++++++++++++++++++++++++++++++++++#{resource.inspect}"
    resource.fetch_ip_and_country(request)
    resource.save!
  end
end
