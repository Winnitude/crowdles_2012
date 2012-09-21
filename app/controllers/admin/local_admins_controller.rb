class Admin::LocalAdminsController < ApplicationController
  before_filter :should_be_global_admin
  before_filter :get_local_admin, :except => [:index]
  def index
    @local_admins = PlatformLocalAdmin.all.includes([:la_general_setting,:user])
    if(params[:re_query])
      #@local_admins = PlatformLocalAdmin.all.includes([:la_general_setting,:user])
      if params[:la_country] != ""
        #pattern = Regexp.new params[:la_country].downcase
        @local_admins = @local_admins.select{|i| i.la_general_setting.la_country.downcase == params[:la_country].downcase rescue nil}
      end

      if params[:language] != ""
        #pattern = Regexp.new params[:la_country].downcase
        @local_admins = @local_admins.select{|i| i.la_general_setting.la_language.downcase == params[:language].downcase rescue nil}
      end

      if params[:master] != "All"
        value = params[:master].downcase== "true" ? true : false
        @local_admins = @local_admins.select{|i| i.is_master == value rescue nil}
      end

      if params[:status] != "All"
        @local_admins = @local_admins.select{|i| i.status.downcase == params[:status].downcase rescue nil}
      end

      if params[:name] != ""
        local_admins_searched_via_first_name = @local_admins.select{|i| i.user.user_profile.first_name.downcase == params[:name].downcase rescue nil}
        local_admins_searched_via_last_name = @local_admins.select{|i| i.user.user_profile.last_name.downcase == params[:name].downcase rescue nil}
        @local_admins = local_admins_searched_via_first_name + local_admins_searched_via_last_name
      end

    else
      @countries = ServiceCountry.all
    end
    @local_admins = @local_admins.paginate(:page => params[:page], :per_page => 10)
  end

  def edit_la_general_settings
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
    @countries = ServiceCountry.all.collect{|i| i.country_english_name}
    #@general_setting = @local_admin.la_general_setting
    #@profile =@local_admin.la_profile
  end

  def update_la_general_settings
    #@profile =@local_admin.la_profile
    #@general_setting= @local_admin.la_general_setting
    if @local_admin.update_attributes(params[:platform_local_admin])

      redirect_to local_admins_path, :notice => "Local Admin General Settings Updated Successfully"
    else
      @languages = ServiceLanguage.all.collect{|i| i.english_name}
      @countries = ServiceCountry.all.collect{|i| i.country_english_name}
      render :edit_la_general_settings
    end
  end

  def get_local_admin
    @local_admin = PlatformLocalAdmin.find params[:id]
  end

end
