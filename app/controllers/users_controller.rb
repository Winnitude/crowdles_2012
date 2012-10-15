class UsersController < ApplicationController
  before_filter :should_be_user ,:get_user , :check_authorization
  before_filter :get_languages_and_countries  ,:only => [:settings]

  def settings
    @profile = @user.user_profile || @user.build_user_profile
  end

  def update_settings
    params[:user][:user_profile][:birth_date] = date
    params[:user][:user_profile][:news_letter_flag] = params[:user][:user_profile][:news_letter_flag] == "1" ? true : false
    @profile = @user.user_profile || @user.build_user_profile
    @user.update_attributes(params[:user])
    @profile.update_attributes(params[:user][:user_profile])
    redirect_to settings_user_path(@user) ,:notice => "User settings updated"
  end

  def change_email

  end

  def update_email
    @user_persisted = User.find params[:id]
    @user.email = params[:user][:email]
    if @user.valid?
      EmailChanged.to_older_email(@user_persisted ).deliver
    end
    if @user.save
      EmailChanged.to_new_email(@user).deliver
      redirect_to settings_profiles_path , :notice => "Email changed successfully"
    else
      render :action => :change_email
    end
  end


  protected
  def get_user
    @user = User.find(params[:id])
    logger.info @user.inspect
  end

  def get_languages_and_countries
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
  end

  def check_authorization
    redirect_to "/" ,:notice => "You are not authorise to perform this action" unless (current_user == @user || current_user.all_roles.include?("global_admin"))

  end
end
