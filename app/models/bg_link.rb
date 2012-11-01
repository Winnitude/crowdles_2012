class BgLink
  include Mongoid::Document
  belongs_to :platform_business_group
  field :main_website, :type => String
  field :blog, :type => String
  field :facebook_page, :type => String
  field :twitter_account, :type => String
  field :four_square_account, :type => String
  field :pinterest, :type => String
  field :youtube_channel, :type => String
  field :vimeo_channel, :type => String
end
