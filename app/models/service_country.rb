class ServiceCountry
  include Mongoid::Document
  field :is_active, :type => Integer
  field :is_default, :type => Integer
  field :user_country, :type => Integer
  field :country_local_name, :type => String
  field :country_english_name, :type => String
  field :iso_code, :type => String
end
