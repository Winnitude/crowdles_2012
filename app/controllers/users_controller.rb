require 'cgi'
require 'profile'
require 'caller'
class UsersController < ApplicationController

  before_filter :should_be_user ,:get_user , :check_authorization
  before_filter :get_languages_and_countries  ,:only => [:settings]
  @@profile = PayPalSDKProfiles::Profile
  @@ep=@@profile.endpoints
  @@clientDetails=@@profile.client_details

  def settings
    #todo date_issue
    @profile = @user.user_profile || @user.build_user_profile
  end

  def update_settings
    #params[:user][:user_profile][:birth_date] = date_formatter(params[:user][:user_profile][:birth_date])
    params[:user][:user_profile][:news_letter_flag] = params[:user][:user_profile][:news_letter_flag] == "1" ? true : false
    @profile = @user.user_profile || @user.build_user_profile
    @user.update_attributes(params[:user])
    @profile.update_attributes(params[:user][:user_profile])
    redirect_to settings_user_path(@user) ,:notice => "User settings updated"
  end

  def edit_address
    #todo ITU Check
    @contact = @user.user_contact || @user.build_user_contact
    logger.info @contact.inspect
  end

  def update_address
    @contact = current_user.user_contact || current_user.build_user_contact
    @contact.update_attributes(params[:user][:user_contact])
    redirect_to  edit_address_user_path(@user)  , :notice => "address updated"
  end

  def change_email

  end

  def update_email
    @user_persisted = User.find params[:id]
    @user.email = params[:user][:email]
    if @user_persisted.email == params[:user][:email]
      redirect_to settings_user_path(@user) ,:notice => "Email Not changed"
    else
      if @user.valid?
        EmailChanged.to_older_email(@user_persisted ).deliver
      end
      if @user.save
        EmailChanged.to_new_email(@user).deliver
        redirect_to settings_user_path(@user) , :notice => "Email changed successfully"
      else
        render :action => :change_email
      end
    end
  end

  def edit_links
    @profile = @user.user_profile || @user.build_user_profile
    @link = @user.user_link || @user.build_user_link
  end

  def update_links
    #status = working_url?(params[:user][:user_profile][:video])
    #logger.info status.inspect
    @profile = @user.user_profile || @user.build_user_profile
    @link = current_user.user_link || current_user.build_user_link
    @link.update_attributes(params[:user][:user_link])
    @profile.update_attributes(params[:user][:user_profile])
    flash[:notice] = "Links updated"
    redirect_to  edit_links_user_path(@user)
  end

  def billing_profile
    countries = ServiceCountry.where.all
    @countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @billing_profile = @user.default_billing_profile || @user.build_default_billing_profile
  end

  def update_billing_profile
    if params["Setting Paypal"] == "Set"
      @@ep["SERVICE"]="/AdaptiveAccounts/GetVerifiedStatus"
      @caller =  PayPalSDKCallers::Caller.new(false)
      req={
          "requestEnvelope.errorLanguage" => "en_US",
          "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
          "clientDetails.deviceId" =>@@clientDetails["deviceId"],
          "clientDetails.applicationId" => @@clientDetails["applicationId"],
          "emailAddress"=>params[:paypal_email],
          "matchCriteria" =>"NAME",
          "firstName" =>params[:paypal_first_name],
          "lastName"=>params[:paypal_last_name]
      }
      #Make the call to PayPal to get verified status on behalf of the caller If an error occured, show the resulting errors
      @transaction = @caller.call(req)
      if (@transaction.response["responseEnvelope.ack"].first =="Success")
        session[:verifiedStatus_response]=@transaction.response
        redirect_to details_adaptive_payments_path
      else
        session[:paypal_error]=@transaction.response
        redirect_to  error_adaptive_payments_path
      end
    else
      @billing_profile = @user.default_billing_profile || @user.build_default_billing_profile
      @billing_profile.update_attributes(params[:default_billing_profile])
      redirect_to billing_profile_user_path(@user), :notice => "Billing profile updated"
    end
  end

  def terms_of_use
    terms =  GaTerm.first.user_terms
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
