class Admin::CurrenciesController < ApplicationController
  def index
    #@currencies = ServiceCurrency.all.paginate(:page => params[:page], :per_page => 10)
    if(params[:re_query])
      @currencies = ServiceCurrency.all
      if params[:name] != ""
        @currencies = @currencies.select{|i| i.country_english_name.downcase == params[:name].downcase rescue nil}
      end

      if params[:iso_code] != ""
        @currencies = @currencies.select{|i| i.iso_code.downcase == params[:iso_code].downcase rescue nil}
      end

      if params[:local_name] != ""
        @currencies = @currencies.select{|i| i.country_local_name.downcase == params[:local_name].downcase rescue nil}
      end

      if params[:is_active] != "All"
        is_active = params[:is_active].downcase == "true" ? 1 : 0
        @currencies = @currencies.select{|i| i.is_active == is_active  rescue nil}
      end

      if params[:user_country] != "All"
        user_country = params[:user_country].downcase == "true" ? 1 : 0
        @currencies = @currencies.select{|i| i.user_country == user_country}
      end

      if params[:is_default] != "All"
        is_default = params[:is_default].downcase == "true" ? 1 : 0
        @currencies = @currencies.select{|i| i.is_default == is_default}
      end

    else
      @currencies = ServiceCurrency.all
    end
    @currencies = @currencies.paginate(:page => params[:page], :per_page => 10)
  end
end
