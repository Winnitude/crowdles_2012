class BgSocial
  include Mongoid::Document
  belongs_to :platform_business_group
 ## field :followers ,                     will be implemented via relationships
 # field :rates,                        :type => Float
  field :recommended,                        :type => Boolean

end
