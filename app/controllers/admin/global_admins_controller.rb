class Admin::GlobalAdminsController < ApplicationController

  before_filter :should_be_global_admin,:except=>[:set_platform_page,:set_platform ]
  before_filter :get_global_admin ,:except=>[:set_platform_page,:set_platform ]
  before_filter :is_user_exist? ,:only=>[:create_user]
  def set_platform_page
    countries = ServiceCountry.where.all
    @user_countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @master_country = countries.collect{|i|i.country_english_name}
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
  end

  def set_platform
    ServiceLanguage.make_language_active_and_default(params[:language])
    ServiceCountry.make_country_default(params[:platform_master_country])
    @user= User.create_global_admin_owner(params) #create 1st user

    @user.initialize_default_billing_profile params #creating default billing profile for user
                                                  #creating GA and his related setting
    @global_admin = @user.build_platform_global_admin
    @global_admin.save

    #creating all settings related to GA
    @global_admin.create_all_settings params ,@user

    logger.info("--------------------------------------------------------------------------------------------GA-------------DONE")

    #creating the Default Product
    PlatformProduct.create_platform_default_product
    logger.info("--------------------------------------------------------------------------------------------ProDuct-------------DONE")
    #creating_local_admin_for_platform_master_country also this will act as MLA
    main_local_admin = PlatformLocalAdmin.create_main_local_admin @user, params
    logger.info("--------------------------------------------------------------------------------------------MLA-------------DONE")
    PlatformAdminGroup.create_main_admin_group_for_platform_master_country @user, params, main_local_admin
    logger.info("--------------------------------------------------------------------------------------------MAG-MLA-------------DONE")
    #creating_local_admins_for_the_other_countries_other than the platform master country
    PlatformLocalAdmin.create_all_local_admins_with_their_mag params
    logger.info("--------------------------------------------------------------------------------------------all MLA MAG-------------DONE")
    redirect_to login_path ,:notice => "The Platform Setup has been successfully executed, please login and start to manage "+ GaGeneralSetting.first.platform_name

  end

  def edit_ga_general_settings
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
    @general_setting = @global_admin.ga_general_setting
  end

  def update_ga_general_settings
    @general_setting= @global_admin.ga_general_setting
    @general_setting.update_attributes(params[:ga_general_setting])
    redirect_to edit_ga_general_settings_global_admins_path, :notice => "Global Admin General Settings Updated Successfully"
  end

  def edit_ga_links
    @general_setting = @global_admin.ga_general_setting
  end

  def update_ga_links
    @general_setting= @global_admin.ga_general_setting
    @general_setting.update_attributes(params[:ga_general_setting])
    redirect_to edit_ga_links_global_admins_path, :notice => "Global Admin Links Updated Successfully"
  end

  def edit_ga_default_billing_profile
    countries = ServiceCountry.where.all
    @countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @billing_profile = @global_admin.default_billing_profile
    #render :json => @billing_profile
  end

  def update_ga_default_billing_profile
    @billing_profile= @global_admin.default_billing_profile
    @billing_profile.update_attributes(params[:default_billing_profile])
    redirect_to edit_ga_default_billing_profile_global_admins_path, :notice => "Global Admin Default Billing Profile Updated Successfully"
  end

  def edit_ga_paas_billing_profile
    countries = ServiceCountry.where.all
    @countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @billing_profile = @global_admin.paas_billing_profile
  end

  def update_ga_paas_billing_profile
    @billing_profile= @global_admin.paas_billing_profile
    @billing_profile.update_attributes(params[:paas_billing_profile])
    redirect_to  edit_ga_paas_billing_profile_global_admins_path, :notice => "Global Admin Paas Billing Profile Updated Successfully"
  end

  def  edit_platform_terms
    @terms = @global_admin.ga_term
  end

  def  update_platform_terms
    @terms = @global_admin.ga_term
    @terms.update_attributes(params[:ga_term])
    redirect_to edit_platform_terms_global_admins_path, :notice => "Platform Terms And Conditions Updated Successfully"
  end

  def edit_ga_projects_commissions
    @projects_commissions = @global_admin.ga_projects_commission
  end

  def update_ga_projects_commissions
    @projects_commissions = @global_admin.ga_projects_commission
    @projects_commissions.update_attributes(params[:ga_projects_commission])
    redirect_to edit_ga_projects_commissions_global_admins_path, :notice => "Platform projects commissions Updated Successfully"
  end

  def edit_ga_projects_settings
    @project_setting = @global_admin.ga_projects_setting
  end

  def update_ga_projects_settings
    @project_setting = @global_admin.ga_projects_setting
    if @project_setting.update_attributes(params[:ga_projects_setting])
      redirect_to edit_ga_projects_settings_global_admins_path, :notice => "Projects Settings Updated Successfully"
    end
  end

  def new_user

  end

  def create_user
    @user = User.new(:email => params[:email])
    if @user.save
      @user.build_user_profile(:first_name => params[:first_name] , :last_name => params[:last_name]).save
      redirect_to  all_users_global_admins_path ,:notice => "User Invited"
    end
  end

  def all_users
    #TODO all the searching logic needs to be moved to model

    @users =User.all
    @countries = ServiceCountry.all.collect{|i| i.country_english_name}
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
    if params[:country].present?

    if params[:country] != "All"
      @users = @users.select{|i| i.country == params[:country]}
    end
    if params[:language] != "All"
      @users = @users.select{|i| i.language == params[:language]}
    end
    if params[:status] != "All"
      @users = @users.select{|i| i.status.downcase == params[:status].downcase}
    end
    #if params[:registration_date] != ""
    #  @users = @users.select{|i| i.confirmed_at.to_date == params[:registration_date].to_date rescue nil}
    #end
    #if params[:last_access] != ""
    #  @users = @users.select{|i| i.confirmed_at.to_date == params[:last_access].to_date rescue nil}
    #end
    if params[:gender] != "All"
      @users = @users.select{|i| i.user_profile.gender == params[:gender] rescue nil}
    end
    if params[:first_name] != ""
      @users = @users.select{|i| i.user_profile.first_name.downcase == params[:first_name].downcase rescue nil}
    end
    if params[:last_name] != ""
      @users = @users.select{|i| i.user_profile.last_name.downcase == params[:last_name].downcase rescue nil}
    end

    if params[:email] != ""
      @users = @users.select{|i| i.email.downcase == params[:email].downcase rescue nil}
    end
    end
  end
  private

  def get_global_admin
    logger.info "get GA"
    @global_admin = current_user.platform_global_admin
  end

  def is_user_exist?
    user = User.where(:email=>params[:email]).to_a.first
    if user.present?
      if user.status.downcase == "active"
        redirect_to new_user_global_admins_path ,:notice => "User Already present with this Email Id"
      end

      if user.status.downcase == "new"
        redirect_to user_exists_homes_path(:id =>user)
      end
    end
  end
end


