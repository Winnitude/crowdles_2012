class CommissionsSetting < GlobalAdmin
  include Mongoid::Document
  belongs_to :user
end
