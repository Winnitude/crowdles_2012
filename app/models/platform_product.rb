class PlatformProduct
  include Mongoid::Document
  before_save :change_default
  before_save :initialize_all_commissions
  has_many :platform_products_managements
  scope :get_default_product, where(:is_default => true)
  field :platform_product_name,           :type => String
  field :platform_product_type  ,          :type => String
  field :product_target  ,                 :type => String
  field :is_default , :type => Boolean
  field :is_default_sag , :type => Boolean
  field :bg_private,                       :type => Boolean
  field :bg_window_number,                 :type => Integer
  field :bg_contest_number,               :type => Integer
  field :ag_workers_number,               :type => Integer
  field :bg_custom_commissions,           :type => Boolean
  field :bg_recepient_settings,           :type => Boolean
  field :ag_payment_gateway_commissions_payer_settings    ,:type => Boolean
  field :ag_equity_based_allowed    ,:type => Boolean
  field :product_monthly_price,           :type => Float
  field :product_annual_price,            :type => Float
  field :status,                          :type => String
  field :platform_standard_commissions,     :type => Float
  field :platform_pro_commissions ,          :type => Float
  field :platform_private_commissions,      :type => Float
  field :paas_fees_exemption,               :type => String
  field :fees_exemption_days,               :type => Integer


  def self.create_platform_default_product
    self.create(:platform_product_name => "Default" ,:platform_product_type => "AG" ,:product_target => "MAG",:is_default => true,:bg_private => true ,
                    :bg_custom_commissions => true,:bg_recepient_settings => true ,:ag_payment_gateway_commissions_payer_settings => true ,
                    :ag_equity_based_allowed => true,:product_monthly_price => 0 ,:product_annual_price => 0 ,:status => "unpublished", :paas_fees_exemption => "permanent")
  end

  def change_default
    logger.info "inside change default"
    if self.product_target.downcase == "sag"
      if self.is_default_sag == true
        previous_default=PlatformProduct.where(:is_default_sag => true).first
        if previous_default.present? && previous_default != self
          previous_default.is_default_sag = false
          previous_default.save
        end
      end
    end
    if self.product_target.downcase == "mag"
      if self.is_default == true
        previous_default=PlatformProduct.where(:is_default => true).first
        if previous_default.present? && previous_default != self
          previous_default.is_default = false
          previous_default.save
        end
      end
    end

  end

  def is_taken_by_ag?
    self.platform_products_managements.present?
  end

  def get_bg_window_number
    self.bg_window_number.present?  ? self.bg_window_number :  "unlimited"
  end

  def get_bg_contest_number
    self.bg_contest_number.present? ?  self.bg_contest_number   :  "unlimited"
  end

  def get_ag_workers_number
    self.ag_workers_number.present?    ? self.ag_workers_number :  "unlimited"
  end

  def get_monthly_price
    self.product_monthly_price.present?    ? self.product_monthly_price :  "Empty"
  end

  def initialize_all_commissions
    logger.info "inside initialization"
    self.platform_private_commissions = 0.0 unless self.platform_private_commissions
    self.platform_pro_commissions = 0.0 unless self.platform_pro_commissions
    self.platform_standard_commissions = 0.0 unless self.platform_standard_commissions
  end
end
