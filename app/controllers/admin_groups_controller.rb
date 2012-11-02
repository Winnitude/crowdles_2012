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
    trial_length = @plan.trial_interval_length
    trial_unit = @plan.trial_interval_unit
    if trial_length > 0
      render :text => "free"
    else
      render :text => "paid"
    end

    #now = DateTime.now
    #factor = trial_unit == "days" ? 1 : 30
    #
    #trial_ends_at = now  + trial_length * factor
    #@admin_group = current_user.platform_admin_groups.create(:trial_end_at => trial_ends_at)



    #render :json => {:end =>trial_ends_at, :now => now ,:trial => trial_length , :unit => trial_unit}
    #binding.remote_pry
    #if DateTime.now.to_i < @admin_group.trial_end_at.to_i
    #  render :text => "not expired "
    #else
    #  render :text => "expired "
    #end

  end





end
