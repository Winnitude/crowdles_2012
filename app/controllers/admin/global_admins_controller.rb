class Admin::GlobalAdminsController < ApplicationController
  class Admin::GlobalAdminsController < ApplicationController
    def set_platform_page
      countries = CountryDetail.where.all
      @user_countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
      @master_country = countries.select{|i| i.is_active == 1 && i.is_default ==1 }.collect{|i|i.country_english_name}
      @currency = Currency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
      @languages = Language.all.collect{|i| i.english_name}
    end

    def set_platform
      Language.make_language_active(params[:language])
      @user= User.create_global_admin_owner(params)
      @general_settings = GeneralSetting.initialize_global_admin_general_settings(params)
      render :json => @general_settings
    end
  end

end
