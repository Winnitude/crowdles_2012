class AgCommissionsSetting
  include Mongoid::Document
  field :bg_free_standard_commissions_allowed ,     :type => Boolean
  field :bg_free_pro_commissions_allowed ,          :type => Boolean
  field :bg_free_private_commissions_allowed ,      :type => Boolean
end
