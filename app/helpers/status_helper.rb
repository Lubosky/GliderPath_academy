module StatusHelper
  def status_for(resource)
    if resource.published_at?
      if resource.published_at > Time.zone.now
        t('helpers.status.scheduled')
      else
        t('helpers.status.published')
      end
    else
      t('helpers.status.draft')
    end
  end
end
