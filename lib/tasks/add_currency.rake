namespace :add_currency do

  desc "Add currency to Winnitude"
  task :add_currency => :environment do
    require 'csv'
    CSV.foreach(Rails.root.join("currency.csv"),{:col_sep =>";"} ) do |row|
      @currency = ServiceCurrency.create(:iso_code => row[2], :is_active => row[0], :description => row[1])
      #puts @currency.inspect
    end
  end
end

