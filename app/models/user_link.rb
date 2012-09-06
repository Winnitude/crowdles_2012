class UserLink
  include Mongoid::Document
  belongs_to :user
  field :web,            :type => String
  field :blog,           :type => String
  field :social_fb,      :type => String
  field :social_twitter, :type => String
  field :social_linkedin,:type => String
  field :social_myspace, :type => String
end
