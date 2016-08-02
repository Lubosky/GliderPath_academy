module DurationHelper
  def duration_for(resource)
    if resource < 3600
      Time.at(resource).utc.strftime('%-M:%S')
    else
      Time.at(resource).utc.strftime('%-H:%M:%S')
    end
  end

  def duration_in_minutes(resource)
    duration = (resource.to_f / 60).round
    t('helpers.duration_in_minutes.count', count: duration)
  end

  def duration_in_hours(resource)
    if resource < 1800
      duration_in_minutes(resource)
    else
      duration = (resource.to_f / 3600).round
      t('helpers.duration_in_hours.count', count: duration)
    end
  end
end
