namespace :add_country do

  desc "Add country to Winnitude"
  task :add_country => :environment do
    require 'csv'
    CSV.foreach(Rails.root.join("countries.csv"),{:col_sep =>";"} ) do |row|
      @country = ServiceCountry.create(:iso_code => row[5], :is_active => row[0], :is_default => row[1], :user_country => row[2], :country_local_name => row[3], :country_english_name => row[4])
      #puts @country.inspect
    end
  end
end

