class ServiceCurrency
  include Mongoid::Document
  field :iso_code,                   :type => String
  field :is_active,                  :type => Integer
  field :description,                :type => String
end