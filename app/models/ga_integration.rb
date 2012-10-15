class GaIntegration
  include Mongoid::Document
  belongs_to :platform_global_admin
  field :mailchimp_integration_enabled,       :type => Boolean, :default => false
  field :freshbooks_integration_enabled,      :type => Boolean, :default => false
end
