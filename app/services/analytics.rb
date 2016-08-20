class Analytics

  class_attribute :backend
  self.backend = IntercomRuby

  def initialize(user)
    @user = user
  end

  def track_lesson_started(course:, lesson:)
    track('Started lesson',
      course: course,
      lesson: lesson
    )
  end

  def track_lesson_completed(course:, lesson:)
    track('Completed lesson',
      course: course,
      lesson: lesson
    )
  end

  def track_product_purchased(type:, product:,price:)
    track('Purchased product',
      type: type,
      product: product,
      price: price
    )
  end

  def track_course_enrolled(course:)
    track('Enrolled course',
      course: course
    )
  end

  def track_course_completed(course:)
    track('Completed course',
      course: course
    )
  end

  def track_downloaded(file:, type:, source:)
    track('Downloaded file',
      file: file,
      type: type,
      source: source
    )
  end

  def track_forum_accessed
    track('Logged into Forum')
  end

  def track_cancelled
    track('Cancelled subscription')
  end

  def track_subscribed(plan:, revenue:)
    track('Subscribed',
      plan: plan,
      revenue: revenue,
    )
  end

  private

    attr_reader :user

    def track(event, metadata = {})
      backend.events.create(
        event_name: event,
        created_at: Time.now.to_i,
        email: user.email,
        metadata: metadata,
      )
    end
end
