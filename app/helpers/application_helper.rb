module ApplicationHelper
  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end

  def platform_name
    if GaGeneralSetting.first.present?
      GaGeneralSetting.first.platform_name
    else
      "Winnitude"
    end
  end
end
