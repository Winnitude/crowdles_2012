namespace :add_language do

  desc "Add language to Winnitude"
  task :add_language => :environment do
    require 'csv'
    CSV.foreach(Rails.root.join("languages.csv"),{:col_sep =>";"} ) do |row|
      @language = Language.create(:iso_code => row[3], :is_active => row[0],:local_name => row[1], :english_name => row[2])
      puts @language.inspect
    end
  end
end

