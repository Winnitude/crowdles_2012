class BgTerm
  include Mongoid::Document
  belongs_to :platform_business_group
  field :latitude, :type => String
end
