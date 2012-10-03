class UserRegistrationsController < ApplicationController
  def register
    @user = current_user
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @language = ServiceLanguage.all.select{|i| i.is_active ==1}.collect{|i| i.english_name}
  end

  def finalize_register
    @user = current_user
    @profile = @user.user_profile
    @profile ||= @user.build_user_profile
    @user.update_attributes(params[:user])
    @user.update_attribute(:status,"active")
    @profile.update_attributes(params[:user_profile])
    sign_in(@user)
    redirect_to root_path
  end
end
