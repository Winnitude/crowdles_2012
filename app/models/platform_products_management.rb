class PlatformProductsManagement
  include Mongoid::Document
  belongs_to :platform_admin_group
  belongs_to :platform_product
end
