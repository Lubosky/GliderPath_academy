module DurationHelper
  def duration_for(resource)
    if resource < 3600
      Time.at(resource).utc.strftime('%-M:%S')
    else
      Time.at(resource).utc.strftime('%-H:%M:%S')
    end
  end
end
