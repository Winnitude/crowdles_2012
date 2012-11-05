class BgLocation
  include Mongoid::Document
  belongs_to :platform_business_group
  #field :country, :type => String
  #field :state, :type => String
  #field :city, :type => String
  #field :zipcode, :type => String
  #field :address, :type => String
  #field :additional_address, :type => String
  #field :contact_number1, :type => String
  #field :Contact_number2, :type => String
  field :longitude, :type => String
  field :latitude, :type => String
end
