class AdminGroupsController < ApplicationController
  before_filter :should_be_user
  before_filter  :checking_access_to_billing_details_page , :only => [:billing_details]
  def new
    @admin_group = PlatformAdminGroup.new
    @products = PlatformProduct.all
    @local_admins = PlatformLocalAdmin.includes(:la_general_setting).where(:status => "active")
    #render :json => @products
  end

  def get_product_details
    @product = PlatformProduct.find( params[:product])
    logger.info @product.inspect
    respond_to do |format|
      format.js
    end
  end

  def create
    if params[:terms] != "1"
      @admin_group = PlatformAdminGroup.new
      @products = PlatformProduct.all
      @local_admins = PlatformLocalAdmin.includes(:la_general_setting).all.select{|i| i.status =="active"}
      flash[:error] = "Terms and Countries need to be accepted"
      render :action => :new
    else
      @product = PlatformProduct.find( params[:product])
      @local_admin = PlatformLocalAdmin.find(params[:local_admin])
      #create new AG for that user

      @admin_group = current_user.platform_admin_groups.new(:admin_group_type =>"slave" ,:status => "new")
      @admin_group.platform_local_admin = @local_admin
      @admin_group.save!
      PlatformProductsManagement.grant_product @product, @admin_group
      PlatformRolesManagement.assign_admin_group_owner_role current_user,@admin_group
      #admin_group.build_all_mag_settings local_admin,param
      #grant product to AG
      #grant adminGroupOwner Role to user
      #set the billing profiles of user
      # Create a BusinessGroup for that AG
    end
  end

  def new_platform
    @admin_group =current_user.platform_admin_groups.new
    session[:platform_product_id] = params[:id]
    @local_admins = PlatformLocalAdmin.includes(:la_general_setting).where(:status => "active")
  end

  def create_platform
    @product= PlatformProduct.find(session[:platform_product_id])
    @plan = @product.get_plan
    @local_admin = PlatformLocalAdmin.find(params[:local_admin])
    trial_length = @plan.trial_interval_length
    #trial_unit = @plan.trial_interval_unit
    if trial_length > 0
      #calculating trial ending
      factor = @plan.trial_interval_unit == "days" ? 1 : 30
      trial_ends_at = DateTime.now  + trial_length * factor
      @admin_group = PlatformAdminGroup.create_account(params,current_user,@local_admin, @product,"active",trial_ends_at)
      session[:platform_product_id] = nil
      redirect_to welcome_admin_group_path(@admin_group)
      #render :text => "free"
    else
      @admin_group = PlatformAdminGroup.create_account(params,current_user,@local_admin, @product,"new",nil)
      redirect_to billing_details_path(:account => @admin_group.id, :plan => @product)

      session[:platform_product_id] = nil
    end
  end

  def welcome
    @admin_group = PlatformAdminGroup.find(params[:id])
  end

  def home
    @admin_group = PlatformAdminGroup.find(params[:id])
  end

  def billing_details
    #this action is taking the billing info at the time of expiration free trial period of ag
    #todo need to check weather ag allow to be on this page or not
    @admin_group = PlatformAdminGroup.find(params[:account])
    @product = PlatformProduct.find params[:plan]
    #replace plan with new
    @admin_group.replace_product(@product)
    #craeate account on recurly
    #binding.remote_pry
    @account = Recurly::Account.new(:account_code => @admin_group.id)
    @countries = ServiceCountry.all.select{|i| i.is_active == 1 }.collect{|i|i.country_english_name}
  end

  def create_billing_details_and_subscription
    #binding.remote_pry
    @product = PlatformProduct.find(params[:product_id])
    @admin_group = PlatformAdminGroup.find params[:admin_group_id]
    @account = Recurly::Account.new(:account_code => @admin_group.id)
    @account.email = params[:email]

    @account.billing_info = {
        :first_name         => params[:company_or_individual] == "individual" ? params[:first_name] : params[:company],
        :last_name          => params[:company_or_individual] == "individual" ? params[:first_name] : params[:legal_form],
        :number             => params[:card_number],
        :verification_value => params[:cvv],
        :month              => params[:expire_month],
        :year               => params[:year],
        :vat_number         => params[:vat],
        :phone              => params[:phone],
        :address1           => params[:address],
        :address2           => params[:additional_address],
        :city               => params[:city],
        :state              => params[:state],
        :zip                => params[:zip_code],
        :country            => params[:country],
    }
    if @account.save
      subscription = Recurly::Subscription.create(
          :plan_code => @product.get_plan.plan_code,
          :currency  => 'USD',
          :account   => @account,
          :trial_ends_at => DateTime.now.utc
      )

      redirect_to welcome_admin_group_path(@admin_group)

    else
      @countries = ServiceCountry.all.select{|i| i.is_active == 1 }.collect{|i|i.country_english_name}
      render :action => :billing_details
    end
  end

  def checking_access_to_billing_details_page
    begin
      account= Recurly::Account.find(params[:account])
    rescue
      account = nil
    end
    redirect_to home_path if account.present?
  end
end
