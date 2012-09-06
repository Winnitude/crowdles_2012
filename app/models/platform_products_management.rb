class PlatformProductsManagement
  include Mongoid::Document
  belongs_to :platform_admin_group
  belongs_to :platform_product

  def self.grant_product product, admin_group
    product_grant = admin_group.build_platform_products_management
    product_grant.platform_product = product
    product_grant.save
  end
end
