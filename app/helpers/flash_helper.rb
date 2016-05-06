module FlashHelper
  def alert_for(message_type)
    case message_type.to_sym
    when :alert, :danger, :error, :validation_error
      'danger'
    when :warning
      'warning'
    when :notice, :success
      'success'
    else
      'info'
    end
  end
end
