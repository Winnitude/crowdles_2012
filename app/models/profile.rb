class Profile
  include Mongoid::Document
  belongs_to :user
end
