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
    #TODO validations need to be implemented
    @languages = ServiceLanguage.all.collect{|i| i.english_name}
    @countries = ServiceCountry.all.collect{|i| i.country_english_name}
    @general_setting = @local_admin.la_general_setting
    @profile =@local_admin.la_profile
    @paas_setting =@local_admin.la_paas_setting
    @la_owner = @local_admin.user
    @ga_owner = PlatformGlobalAdmin.first.user
    @local_admins = PlatformLocalAdmin.all.includes(:la_general_setting).select{|i| i.status == "active"}.collect{|i| i.la_general_setting.local_admin_name}
  end

  def update_la_general_settings
    @paas_setting =@local_admin.la_paas_setting
    @profile =@local_admin.la_profile
    @general_setting= @local_admin.la_general_setting
    if @general_setting.update_attributes(params[:platform_local_admin][:la_general_setting]) and @profile.update_attributes(params[:platform_local_admin][:la_profile]) and @paas_setting.update_attributes(params[:platform_local_admin][:la_paas_setting])
      @local_admin.update_attributes(params[:platform_local_admin])
      redirect_to edit_la_general_settings_local_admin_path(@local_admin), :notice => "Local Admin General Settings Updated Successfully"
    else
      @languages = ServiceLanguage.all.collect{|i| i.english_name}
      @countries = ServiceCountry.all.collect{|i| i.country_english_name}
      render :edit_la_general_settings
    end
  end

  def edit_la_paas_billing_profile
    countries = ServiceCountry.where.all
    @countries = countries.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @currency = ServiceCurrency.all.select{|i| i.is_active == 1 }.collect{|i| i.description}
    @billing_profile = @local_admin.paas_billing_profile
  end

  def update_la_paas_billing_profile
    @billing_profile= @local_admin.paas_billing_profile
    @billing_profile.update_attributes(params[:paas_billing_profile])
    redirect_to edit_la_paas_billing_profile_local_admin_path(@local_admin), :notice => "Local Admin Paas Billing Profile Updated Successfully"
  end

  def edit_la_terms
    @terms = @local_admin.la_term
  end

  def update_la_terms
    @terms = @local_admin.la_term
    @terms.update_attributes(params[:la_term])
    redirect_to edit_la_terms_local_admin_path(@local_admin), :notice => "Local Admin Terms Updated Successfully"
  end

  def edit_la_organization_details
   #This Action will update both LA profile as well as LA contact details
   #TODO validations need to be implemented
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
    @profile = @local_admin.la_profile
    @contact = @local_admin.la_contact
  end

  def update_la_organization_details
    @profile =@local_admin.la_profile
    @contact = @local_admin.la_contact
    #binding.remote_pry
    if !(params[:platform_local_admin][:la_contact]["contact_photo"].present?) or is_image?(params[:platform_local_admin][:la_contact]["contact_photo"].content_type)
      if @contact.update_attributes(params[:platform_local_admin][:la_contact]) and @profile.update_attributes(params[:platform_local_admin][:la_profile])
        redirect_to edit_la_organization_details_local_admin_path(@local_admin), :notice => "Local Admin General Settings Updated Successfully"
      else
        @countries = ServiceCountry.all.collect{|i| i.country_english_name}
        render :edit_la_organization_details
      end
    else
      @countries = ServiceCountry.all.select{|i| i.is_active == 1 && i.user_country ==1 }.collect{|i|i.country_english_name}
      flash[:notice] = "invalid image"
      render :edit_la_organization_details
    end


  end


  def get_local_admin
    @local_admin = PlatformLocalAdmin.find params[:id]
  end

end
