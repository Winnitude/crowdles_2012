class PlansController < ApplicationController
  def index
    #binding.remote_pry
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
end
