
class Admin::ProductsController < ApplicationController
  before_filter :should_be_global_admin
  # GET /products
  # GET /products.json
  def index
    if(params[:re_query])
      @products = PlatformProduct.all
      if params[:name] != ""
        @products = @products.select{|i| i.platform_product_name.downcase == params[:name].downcase rescue nil}
      end

      if params[:target] != "All"
        @products = @products.select{|i| i.product_target.downcase == params[:target].downcase rescue nil}
      end
      if params[:status] != "All"
        @products = @products.select{|i| i.status.downcase == params[:status].downcase rescue nil}
      end
      if params[:promotions] != "All"
        @products = @products.select{|i| i.paas_fees_exemption.downcase == params[:promotions].downcase rescue nil}
      end

      if params[:standard].downcase != "sort"
        @products = @products.sort_by{|i| i.platform_standard_commissions}
        @products = @products.reverse if  params[:standard].downcase == "descending"
      end

      if params[:pro].downcase != "sort"
        @products = @products.sort_by{|i| i.platform_pro_commissions}
        @products = @products.reverse if  params[:pro].downcase == "descending"
      end

      if params[:private].downcase != "sort"
        @products = @products.sort_by{|i| i.platform_private_commissions}
        @products = @products.reverse if  params[:private].downcase == "descending"
      end

      if params[:monthly_price].downcase != "sort"
        @products = @products.sort_by{|i| i.product_monthly_price}
        @products = @products.reverse if  params[:monthly_price].downcase == "descending"
      end

      if params[:annual_price].downcase != "sort"
        @products = @products.sort_by{|i| i.product_annual_price}
        @products = @products.reverse if  params[:annual_price].downcase == "descending"
      end

    else
      @products = PlatformProduct.all
    end
  end


  def new
    @product = PlatformProduct.new
  end

  # GET /products/1/edit
  def edit
    @product = PlatformProduct.find(params[:id])
    @plan = @product.get_plan
  end

  # POST /products
  # POST /products.json
  def create

    @product = PlatformProduct.new(params[:platform_product])
    @product.is_default_sag= params[:default] if @product.product_target.downcase == "sag"
    @product.is_default= params[:default]  if @product.product_target.downcase == "mag"
    respond_to do |format|
      if @product.save
        plan = Recurly::Plan.create(
            :plan_code            => @product.id,
            :name                 => params[:plan_name],
            :description          => params[:description],
            :unit_amount_in_cents => { 'USD' => params[:amount]},
            :plan_interval_length => params[:plan_interval_length],
            :plan_interval_unit   => params[:plan_interval_unit],
            :trial_interval_length   => params[:trial_interval_length],
            :trial_interval_unit   => params[:trial_interval_unit]
        )
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end


  # PUT /products/1
  # PUT /products/1.json
  def update
    if params[:platform_product][:product_monthly_price].to_f > params[:platform_product][:product_annual_price].to_f
      redirect_to edit_product_path(@product) , :notice => "monthly price should not greater than annual"
    else
      @product = PlatformProduct.find(params[:id])
      @product.is_default_sag= params[:default] if @product.product_target.downcase == "sag"
      @product.is_default= params[:default]  if @product.product_target.downcase == "mag"
      respond_to do |format|
        if @product.update_attributes(params[:platform_product])
          @plan = @product.get_plan
          @plan.update_attributes(
              :name                 => params[:plan_name],
              :description          => params[:description],
              :unit_amount_in_cents => { 'USD' => params[:amount]},
              :plan_interval_length => params[:plan_interval_length],
              :plan_interval_unit   => params[:plan_interval_unit],
              :trial_interval_length   => params[:trial_interval_length],
              :trial_interval_unit   => params[:trial_interval_unit]
          )
          format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end
  end

  def destroy
    @product = PlatformProduct.find(params[:id])
    @plan = @product.get_plan
    if @product.destroy
      @plan.destroy
    end
    respond_to do |format|
      format.html { redirect_to products_path ,:notice =>"Deleted successfully" }
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json

end


