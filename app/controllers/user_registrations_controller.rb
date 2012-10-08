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
    @user.build_default_billing_profile.save
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

  def create_new_user
    @user = User.new(:email => session[:facebook_data][:fb_email],
                     :facebook_id =>session[:facebook_data][:fb_id],
                     :password => Devise.friendly_token[0,20],
                     :is_provider => true,
                     :is_proprietary_user => false,
                     :created_at => Time.now,
                     :status => "new"
    )
    @profile = @user.build_user_profile(:first_name =>session[:facebook_data][:fb_first_name], :last_name =>session[:facebook_data][:fb_last_name] ,:gender =>session[:facebook_data][:gender] ,:fb_image => session[:facebook_data][:fb_image] )
    @user.confirm!
    @user.save!
    @user.build_default_billing_profile.save
    @profile.save
    session[:facebook_data] = nil
    sign_in_and_redirect(@user)
  end

  def connect_fb_and_crowdles
    @user = User.where(:email => session[:temp_crowdles_data][:email]).first
    @user.update_attributes(:facebook_id => session[:facebook_data][:fb_id],:is_provider => true )
    session[:facebook_data] = nil
    session[:temp_crowdles_data] = nil
    sign_in_and_redirect(@user)
  end
end
