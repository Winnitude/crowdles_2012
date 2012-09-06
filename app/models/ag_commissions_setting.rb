class AgCommissionsSetting
  include Mongoid::Document
  belongs_to :platform_admin_group
  field :bg_free_standard_commissions_allowed ,     :type => Boolean
  field :bg_free_pro_commissions_allowed ,          :type => Boolean
  field :bg_free_private_commissions_allowed ,      :type => Boolean
end
