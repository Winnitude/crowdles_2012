class GaProjectsCommission
  include Mongoid::Document
  belongs_to :platform_global_admin
  field :gateway_commissions_payer,       :type => String, :default => "Project Owner"
  field :standard_commission_status,      :type => String, :default => "succeeded"
  field :global_admin_standard_commissions_quote, :type => Float
  field :global_admin_pro_commissions_quote, :type => Float
  field :global_admin_private_commissions_quote, :type => Float
end
