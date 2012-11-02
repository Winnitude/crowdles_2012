class BgAdditionalTerm
  include Mongoid::Document
  belongs_to :platform_business_group
  field :additional_terms, :type => String
end
