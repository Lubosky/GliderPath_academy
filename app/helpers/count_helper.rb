module CountHelper
  def completed_lesson_count_for(resource)
    resource_class = modelize(resource)
    resource_class.completed_lessons_count_for(current_user)[resource.id] ||= 0
  end

  def content_length_for(resource)
    resource_class = modelize(resource)
    resource_class.content_length[resource.id] ||= 0
  end

  def lesson_count_for(resource)
    resource_class = modelize(resource)
    resource_class.lesson_count[resource.id] ||= 0
  end

  def enrollment_count_for(resource)
    count = @dashboard.enrollment_count[resource.id] ||= 0
    t('helpers.enrollments.count', count: count)
  end

  def purchase_count_for(resource)
    count = @dashboard.purchase_count[resource.id] ||= 0
    t('helpers.purchases.count', count: count)
  end

  def modelize(resource)
    resource.model_name.human.constantize
  end
end
