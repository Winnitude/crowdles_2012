class Admin::CountriesController < ApplicationController
  def index
    #@countries = ServiceCountry.all.paginate(:page => params[:page], :per_page => 10)
    if(params[:re_query])
      @countries = ServiceCountry.all
      if params[:name] != ""
        @countries = @countries.select{|i| i.country_english_name.downcase == params[:name].downcase rescue nil}
      end

      if params[:iso_code] != ""
        @countries = @countries.select{|i| i.iso_code.downcase == params[:iso_code].downcase rescue nil}
      end

      if params[:local_name] != ""
        @countries = @countries.select{|i| i.country_local_name.downcase == params[:local_name].downcase rescue nil}
      end

      if params[:is_active] != "All"
        is_active = params[:is_active].downcase == "true" ? 1 : 0
        @countries = @countries.select{|i| i.is_active == is_active  rescue nil}
      end

      if params[:user_country] != "All"
        user_country = params[:user_country].downcase == "true" ? 1 : 0
        @countries = @countries.select{|i| i.user_country == user_country}
      end

      if params[:is_default] != "All"
        is_default = params[:is_default].downcase == "true" ? 1 : 0
        @countries = @countries.select{|i| i.is_default == is_default}
      end

    else
      @countries = ServiceCountry.all
    end
    @countries = @countries.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
   @country = ServiceCountry.find(params[:id])
  end

  def update
    @country = ServiceCountry.find(params[:id])
    if @country.update_attributes(params[:service_country])
      redirect_to countries_path ,:notice => "Country Updated Successfully"
    end
  end
end


#if(params[:re_query])
#  @products = PlatformProduct.all
#  if params[:name] != ""
#    @products = @products.select{|i| i.platform_product_name.downcase == params[:name].downcase rescue nil}
#  end
#
#  if params[:target] != "All"
#    @products = @products.select{|i| i.product_target.downcase == params[:target].downcase rescue nil}
#  end
#  if params[:status] != "All"
#    @products = @products.select{|i| i.status.downcase == params[:status].downcase rescue nil}
#  end
#else
#  @products = PlatformProduct.all
#end