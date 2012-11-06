class PlansController < ApplicationController
  before_filter  :checking_access_to_reselect_plan_page , :only => [:select_plan]
  def index
    #binding.remote_pry
    session[:platform_product_id] =nil
    products = PlatformProduct.get_products_with_existing_plans
    @products = products[:products]
    @products=@products.paginate(:page => params[:page], :per_page => 4)
    @plans = products[:plans]
  end

  def select_plan
    #todo need to check weather Ag is allowed to be on this page or not
    @admin_group = PlatformAdminGroup.find params[:id]
    products = PlatformProduct.get_products_with_existing_plans
    @products = products[:products]
    @products=@products.paginate(:page => params[:page], :per_page => 4)
    @plans = products[:plans]
  end

  def checking_access_to_reselect_plan_page
    @admin_group = PlatformAdminGroup.find params[:id]
    redirect_to root_path if @admin_group.is_subscribed == true
  end
end
