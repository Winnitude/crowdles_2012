class UserRegistrationsController < ApplicationController
  def register
    @user = current_user
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @language = ServiceLanguage.all.select{|i| i.is_active ==1}.collect{|i| i.english_name}
  end

  def finalize_register
    @user = current_user
    @profile = @user.user_profile
    @user.update_attributes(params[:user])
    @profile.update_attributes(params[:user_profile])
    logger.info @user.inspect
    sign_in(@user,:bypass => true)
    redirect_to root_path
  end

  def confirm_facebook
    logger.info(session.inspect)
  end

  def validate_account
    @user = User.where(:email => params[:email]).first
    if @user.present?
      if @user.valid_password?(params[:password])
        render :text => "aya"
      else
        render :text => "wrong crendential"
      end

    else
      render :text => "user_not_find"
    end
  end
end
