class BgCommissionsSetting
  include Mongoid::Document
  belongs_to :platform_business_group
  field :account_standard_commissions,             :type => Float
  field :account_pro_commissions,             :type => Float
end
