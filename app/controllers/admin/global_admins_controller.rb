class Admin::GlobalAdminsController < ApplicationController
  before_filter :should_be_global_admin,:except=>[:set_platform_page,:set_platform ]
  before_filter :get_global_admin ,:except=>[:set_platform_page,:set_platform ]
  def set_platform_page
    countries = ServiceCountry.where.all
    @user_countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @master_country = countries.select{|i| i.is_active == 1 && i.is_default ==1 }.collect{|i|i.country_english_name}
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
  end

  def set_platform
    ServiceLanguage.make_language_active(params[:language])
    @user= User.create_global_admin_owner(params) #create 1st user

    @user.initialize_default_billing_profile params #creating default billing profile for user
                                                  #creating GA and his related setting
    @global_admin = @user.build_platform_global_admin
    @global_admin.save
                                                  #creating all settings related to GA
    @global_admin.create_all_settings params ,@user

    #creating the Default Product
    PlatformProduct.create_platform_default_product
    #creating_local_admin_for_platform_master_country also this will act as MLA
    main_local_admin = PlatformLocalAdmin.create_main_local_admin @user, params
    PlatformAdminGroup.create_main_admin_group_for_platform_master_country @user, params, main_local_admin
    #creating_local_admins_for_the_other_countries_other than the platform master country
    PlatformLocalAdmin.create_all_local_admins_with_their_mag params
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
    redirect_to root_path, :notice => "Global Admin General Settings Updated Successfully"
  end

  def edit_ga_links
    @general_setting = @global_admin.ga_general_setting
  end

  def update_ga_links
    @general_setting= @global_admin.ga_general_setting
    @general_setting.update_attributes(params[:ga_general_setting])
    redirect_to root_path, :notice => "Global Admin Links Updated Successfully"
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
    redirect_to root_path, :notice => "Global Admin Default Billing Profile Updated Successfully"
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
    redirect_to root_path, :notice => "Global Admin Paas Billing Profile Updated Successfully"
  end

  def  edit_platform_terms
    @terms = @global_admin.ga_term
  end

  def  update_platform_terms
    @terms = @global_admin.ga_term
    @terms.update_attributes(params[:ga_term])
    redirect_to root_path, :notice => "Platform Terms And Conditions Updated Successfully"
  end


  private

  def get_global_admin
    logger.info "get GA"
    @global_admin = current_user.platform_global_admin
  end

end


