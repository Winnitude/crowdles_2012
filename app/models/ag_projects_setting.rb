class AgProjectsSetting
  include Mongoid::Document
  belongs_to :platform_admin_group
end
