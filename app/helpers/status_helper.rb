module StatusHelper
  def label_for(resource)
    if resource.published_at?
      if resource.published_at > Time.current
        t('helpers.label.scheduled')
      else
        t('helpers.label.published')
      end
    else
      t('helpers.label.draft')
    end
  end

  def status_for(resource)
    if resource.published_at?
      if resource.published_at > Time.current
        t('helpers.status.scheduled', date: resource.published_at)
      else
        t('helpers.status.published', date: resource.published_at)
      end
    end
  end
end
