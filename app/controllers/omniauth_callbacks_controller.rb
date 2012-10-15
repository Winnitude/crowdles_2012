class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :redirect_to_initial_page_if_platform_is_not_configured_yet
  def facebook
   # logger.info "facebook"
   logger.info request.env["omniauth.auth"]
   #binding.remote_pry
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"],current_user)
    if !@user.new_record?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      if @user.is_provider_terms_of_service
        sign_in_and_redirect(@user)
      else
        set_flash_message(:notice, :is_provider_terms_of_service)
        sign_in(@user)
        redirect_to provider_terms_of_service_people_path
      end
    else
      facebook_data = {:fb_id =>request.env["omniauth.auth"].extra.raw_info["id"], :fb_first_name => request.env["omniauth.auth"].extra.raw_info["first_name"],:fb_last_name => request.env["omniauth.auth"].extra.raw_info["last_name"], :fb_email =>request.env["omniauth.auth"].extra.raw_info.email, :fb_image => request.env["omniauth.auth"].info.image ,:gender =>request.env["omniauth.auth"].extra.raw_info.gender ,:fb_page => request.env["omniauth.auth"].extra.raw_info.link
      }
      session[:facebook_data] = facebook_data
      redirect_to confirm_facebook_path
    end
  end



  #def passthru
  #  render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  #  # Or alternatively,
  #  # raise ActionController::RoutingError.new('Not Found')
  #end
end
