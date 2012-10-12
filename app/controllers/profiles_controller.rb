class ProfilesController < ApplicationController
  before_filter :should_be_user
  before_filter :get_profile

  def edit_address
    @contact = current_user.user_contact || current_user.build_user_contact
    logger.info @contact.inspect
  end

  def update_address
    @contact = current_user.user_contact || current_user.build_user_contact
    @contact.update_attributes(params[:user][:user_contact])
    redirect_to  edit_address_profiles_path()  , :notice => "links updated"
  end

  def edit_links
    @link = current_user.user_link || current_user.build_user_link
    logger.info @contact.inspect
  end

  def update_links
    #status = working_url?(params[:user][:user_profile][:video])
    #logger.info status.inspect
    @link = current_user.user_link || current_user.build_user_link
    @link.update_attributes(params[:user][:user_link])
    @profile.update_attributes(params[:user][:user_profile])
    flash[:notice] = "Links updated"
    redirect_to  edit_links_profiles_path
  end

  def settings
    @user = current_user
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
  end

  def update_settings
    @user = current_user
    @user.update_attributes(params[:user])
    @profile.update_attributes(params[:user][:user_profile])
    redirect_to settings_profiles_path ,:notice => "User settings updated"
  end



  def change_email
    @user = current_user
  end

  def update_email
    @user_persisted = User.find current_user.id
    @user = current_user
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
  def get_profile
    @profile = current_user.user_profile
    logger.info @profile.inspect
  end
end
