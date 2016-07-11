module TimestampHelper

  def timestamp(resource)
    resource.created_at.strftime('%b %e, %Y')
  end

end
