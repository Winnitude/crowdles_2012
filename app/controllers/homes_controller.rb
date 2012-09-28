class HomesController < ApplicationController
  before_filter :should_be_user ,:except => [:platform_not_configured,:user_exists,:send_verification_mail]
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
end
