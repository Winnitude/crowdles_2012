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

  def working_url?(url, max_redirects=6)
    require 'net/http'
    require 'set'
    response = nil
    seen = Set.new
    loop do
      url = URI.parse(url)
      break if seen.include? url.to_s
      break if seen.size > max_redirects
      seen.add(url.to_s)
      response = Net::HTTP.new(url.host, url.port).request_head(url.path)
      if response.kind_of?(Net::HTTPRedirection)
        url = response['location']
      else
        break
      end
    end
    response.kind_of?(Net::HTTPSuccess) && url.to_s
  end

  def format_date date
    Date.strptime(date, '%d-%m-%Y').to_s
  end

  def is_image?(params)
    content_type = params.split("/")
    #binding.remote_pry
    if !content_type.empty?
      if content_type.include?("image")
        return true
      else
        return false
      end
    else
      return true
    end
  end



end
