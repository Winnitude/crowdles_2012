
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
  end

  # POST /products
  # POST /products.json
  def create
    @product = PlatformProduct.new(params[:platform_product])
    @product.is_default_sag= params[:default] if @product.product_target.downcase == "sag"
    @product.is_default= params[:default]  if @product.product_target.downcase == "mag"

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = PlatformProduct.find(params[:id])
    @product.is_default_sag= params[:default] if @product.product_target.downcase == "sag"
    @product.is_default= params[:default]  if @product.product_target.downcase == "mag"
    respond_to do |format|
      if @product.update_attributes(params[:platform_product])
        format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @product = PlatformProduct.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_path ,:notice =>"Deleted successfully" }
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json

end


