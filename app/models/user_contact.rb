class UserContact
  include Mongoid::Document
  field :city,           :type => String
  field :state,          :type => String
  field :zip_code,       :type => String
  field :street,         :type => String
  field :street_number,  :type => String
  field :additional_address_info,      :type => String
  field :main_number,                  :type => String
  field :secondary_number,             :type => String
end
