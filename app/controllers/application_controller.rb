class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :should_be_user
  def should_be_user
    logger.info ("checking session")
    redirect_to new_user_session_path unless current_user
  end

  def check_status_for_user
    logger.info "inside check status"
    logger.info current_user.inspect
    if ((current_user.facebook_id.present?) && (current_user.status.downcase =="new"))
      redirect_to register_path ,:notice => "You need To accepts Terms and Conditions"
    end
  end

  def redirect_to_initial_page_if_platform_is_not_configured_yet
    if PlatformGlobalAdmin.count == 0
      if request.url.index(LOCAL_HOST).present?
        redirect_to   platform_not_configured_homes_path
      else
        redirect_to   set_platform_page_global_admins_path
      end
    end
  end

  def should_be_global_admin
     logger.info("checking for ga privileges")
     redirect_to root_path ,:alert => "You should have GA privileges to perform this" unless current_user.all_roles.include?("global_admin")
  end

  def start_debugging
    binding.remote_pry
  end



end
