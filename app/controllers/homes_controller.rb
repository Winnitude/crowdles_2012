class HomesController < ApplicationController
  before_filter :should_be_user ,:except => [:platform_not_configured,:user_exists,:send_verification_mail]
  before_filter :check_status_for_fb_user, :only => [:index]
  def index

  end
  def platform_not_configured

  end

  def user_exists
    @user = User.find(params[:id])
    logger.info @user.inspect
  end

  def send_verification_mail
    @user = User.find(params[:id])
    @user.send_confirmation_instructions
    redirect_to login_path, :notice=>"Confirmation message send plz confirm it to proceed."
  end

  def check_status_for_fb_user
    logger.info "inside check status"
    logger.info current_user.inspect
    if ((current_user.facebook_id.present?) && (current_user.status.downcase =="new") &&  (current_user.is_proprietary_user== true))
      redirect_to register_path ,:notice => "You need To accepts Terms and Conditions"
    end
 end

end
