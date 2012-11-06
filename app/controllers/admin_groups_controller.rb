class AdminGroupsController < ApplicationController
  before_filter :should_be_user
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
      @admin_group = PlatformAdminGroup.create_account(params,current_user,@local_admin, @product,trial_ends_at)

      global_admin_email = get_global_admin_email
      local_admin_email= get_local_admin_email(@local_admin)

      AgNotification.registration_confirmation(global_admin_email).deliver
      AgNotification.registration_confirmation(local_admin_email).deliver

      redirect_to home_admin_group_path(@admin_group) ,:notice => "Your Platform created successfully now you can manage your own platform Mail send to GA"
      #render :text => "free"
    else
      render :text => "paid"
    end
  end

  def home
    @admin_group = PlatformAdminGroup.find(params[:id])
  end

  def billing_details
    account = Recurly::Account.create(:account_code => params[:admin_group])
  end
end
