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
      @user= User.create_global_admin_owner(params)
      @user.initialize_default_billing_profile params
      @global_admin = PlatformGa.create
      @global_admin.initialize_billing_profiles params
      @general_settings = GaGeneralSetting.initialize_global_admin_general_settings(params)
      render :json => @general_settings
    end
  end

end
