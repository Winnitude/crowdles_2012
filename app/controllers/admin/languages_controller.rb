class Admin::LanguagesController < ApplicationController
  def index
    #@languages = ServiceLanguage.all.paginate(:page => params[:page], :per_page => 10)

    #binding.remote_pry
    if(params[:re_query])
      @languages = ServiceLanguage.all
      if params[:name] != ""
        @languages = @languages.select{|i| i.english_name.downcase == params[:name].downcase rescue nil}
      end

      if params[:iso_code] != ""
        @languages = @languages.select{|i| i.iso_code.downcase == params[:iso_code].downcase rescue nil}
      end

      if params[:local_name] != ""
        @languages = @languages.select{|i| i.local_name.downcase == params[:local_name].downcase rescue nil}
      end

      if params[:is_active].downcase != "all"
        is_active = params[:is_active].downcase == "true" ? 1 : 0
        @languages = @languages.select{|i| i.is_active == is_active }
      end

      if params[:is_default].downcase != "all"
        is_default = params[:is_default].downcase == "true" ? 1 : 0
        @languages = @languages.select{|i| i.is_default == is_default  rescue nil}
      end

    else
      @languages = ServiceLanguage.all
    end
    @languages = @languages.sort_by {|obj| obj.english_name}.paginate(:page => params[:page], :per_page => 10)
    #@countries = @countries.sort_by {|obj| obj.country_english_name}.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @language = ServiceLanguage.find(params[:id])
  end

  def update
    @language = ServiceLanguage.find(params[:id])
    if @language.update_attributes(params[:service_language])
      redirect_to edit_language_path(@language) ,:notice => "language Updated Successfully"
    end
  end
end
