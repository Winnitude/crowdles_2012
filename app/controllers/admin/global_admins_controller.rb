class Admin::GlobalAdminsController < ApplicationController
  class Admin::GlobalAdminsController < ApplicationController
    def set_platform_page
      @countries = CountryDetail.all.collect{|i|i.country_english_name}
      @currency = Currency.all.collect{|i| i.description}
      @languages = Language.all.collect{|i| i.english_name}
    end

    def set_platform

      @user= User.create_global_admin_owner(params)
      @general_settings = GeneralSetting.initialize_global_admin_general_settings(@user, params)
      render :json => @general_settings
    end
  end

end
