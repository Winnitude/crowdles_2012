class AgCommissionsSetting
  include Mongoid::Document
  belongs_to :platform_admin_group
  field :platform_standard_commissions,     :type => Float
  field :platform_pro_commissions ,          :type => Float
  field :platform_private_commissions,      :type => Float
end
