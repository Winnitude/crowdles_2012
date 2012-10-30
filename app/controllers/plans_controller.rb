class PlansController < ApplicationController
  def index
    products = PlatformProduct.get_products_with_existing_plans
    @products = products[:products]
    @plans = products[:plans]
  end
end
