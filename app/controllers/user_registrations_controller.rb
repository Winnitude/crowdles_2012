class UserRegistrationsController < ApplicationController
  def register # this action will ask for registration from the Fb user for that case when the User is present in dataBase with the facebook_email_id = app_email_id and user_status is new
    @user = current_user
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @language = ServiceLanguage.all.select{|i| i.is_active ==1}.collect{|i| i.english_name}
  end

  def finalize_register # after register
    #todo need to create BP also
    @user = current_user
    @profile = @user.user_profile
    @user.update_attributes(params[:user])
    @profile.update_attributes(params[:user_profile])
    logger.info @user.inspect
    sign_in(@user,:bypass => true)
    redirect_to root_path
  end

  def confirm_facebook # this action will ask for registration from the Fb user for that case when the User is new no FB_ID no email IN app will ask user create new account or link with some one
    logger.info(session.inspect)
  end

  def validate_account
    @user = User.where(:email => params[:email]).first
    if @user.present?
      if @user.valid_password?(params[:password])
        profile = @user.user_profile
        temp_crowdles_data = {:first_name => (profile.first_name rescue nil) ,:last_name => (profile.last_name rescue nil) ,:email =>@user.email}
        session[:temp_crowdles_data] = temp_crowdles_data
        redirect_to confirm_path
      else
        redirect_to confirm_facebook_path ,:notice => "Email and Password Do Not Match"
      end

    else
      redirect_to confirm_facebook_path ,:notice => "User not found"
    end
  end

  def final_confirmation
     logger.info(session.inspect)
  end
end
