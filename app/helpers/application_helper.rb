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

  def logged_in?
    if current_user.present?
      true
    else
      false
    end
  end

  def is_platform_ready?
    if PlatformGlobalAdmin.count == 0
      false
    else
      true
    end
  end

  def is_local_host?
    if request.url.index(LOCAL_HOST).present?
      true
    else
      false
    end
  end

  def is_admin_host?
    if request.url.index(ADMIN_HOST).present?
      true
    else
      false
    end
  end

  def user_terms
    GaTerm.first.user_terms
  end

end
