class HomesController < ApplicationController
  before_filter :should_be_user ,:except => [:platform_not_configured]
  def index

  end
  def platform_not_configured

  end
end
