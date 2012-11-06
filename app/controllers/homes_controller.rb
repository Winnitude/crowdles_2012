class HomesController < ApplicationController
  before_filter :should_be_user ,:except => [:platform_not_configured,:user_exists,:send_verification_mail]
  before_filter :check_status_for_user, :only => [:index]
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
    redirect_to login_path, :notice=>"Confirmation message send please confirm it to proceed."
  end
  def show_accounts
    @admin_groups= current_user.platform_admin_groups

   render :json => @admin_groups
  end

end
