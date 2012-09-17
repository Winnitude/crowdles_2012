namespace :all_tasks do

  desc "Add country,currency etc  to Winnitude"
  task :all_tasks => :environment do
    require 'csv'
    CSV.foreach(Rails.root.join("countries.csv"),{:col_sep =>";"} ) do |row|
      @country = ServiceCountry.create(:iso_code => row[5], :is_active => row[0], :is_default => row[1], :user_country => row[2], :country_local_name => row[3], :country_english_name => row[4])
      #puts @country.inspect
    end

    CSV.foreach(Rails.root.join("currency.csv"),{:col_sep =>";"} ) do |row|
      @currency = ServiceCurrency.create(:iso_code => row[2], :is_active => row[0], :description => row[1])
      #puts @currency.inspect
    end

    CSV.foreach(Rails.root.join("languages.csv"),{:col_sep =>";"} ) do |row|
      @language = ServiceLanguage.create(:iso_code => row[3], :is_active => row[0],:local_name => row[1], :english_name => row[2])
      #puts @language.inspect
    end

    roles_array = ["user","worker","global_admin","local_admin", "main_local_admin", "business_group_owner" ,"admin_group_owner" ,"admin_group_worker" ,"main_admin_group_owner"]
    roles_array.each do |role_name|
      role = UserRole.new(:role_name=> role_name)
      role.save
    end
  end
end
