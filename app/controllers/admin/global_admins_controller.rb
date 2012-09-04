class Admin::GlobalAdminsController < ApplicationController
  class Admin::GlobalAdminsController < ApplicationController
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
      @global_admin = PlatformGlobalAdmin.create
      @global_admin.initialize_billing_profiles params
      @general_settings = @global_admin.build_ga_general_setting
      @general_settings.initialize_global_admin_general_settings(params)
      @integration_setting = @global_admin.build_ga_integration.save
      @commissions_setting = @global_admin.build_ga_projects_commission.save
      @terms = @global_admin.build_ga_term.save
      @projects_setting = @global_admin.build_ga_projects_setting.save
      PlatformRolesManagement.assign_global_admin_role @user , @global_admin
      render :json => @general_settings
    end
  end

end
