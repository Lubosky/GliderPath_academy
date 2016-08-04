require 'spec_helper'

describe Analytics do
  let(:user) { build_stubbed(:user) }
  let(:analytics_instance) { Analytics.new(user) }

  describe '#track_lesson_started' do
    it 'tracks started lesson event' do
      course = build_stubbed(:course)
      lesson = build_stubbed(:lesson)

      analytics_instance.track_lesson_started(
        course: course.name,
        lesson: lesson.title
      )

      expect(analytics).to have_tracked('Started lesson').
        for_user(user).
        with_metadata(
          course: course.name,
          lesson: lesson.title
        )
    end
  end

  describe '#track_lesson_completed' do
    it 'tracks completed lesson event' do
      course = build_stubbed(:course)
      lesson = build_stubbed(:lesson)

      analytics_instance.track_lesson_completed(
        course: course.name,
        lesson: lesson.title
      )

      expect(analytics).to have_tracked('Completed lesson').
        for_user(user).
        with_metadata(
          course: course.name,
          lesson: lesson.title
        )
    end
  end

  describe '#track_product_purchased' do
    it 'tracks purchase event' do
      course = build_stubbed(:course)
      purchase = build_stubbed(:purchase)

      analytics_instance.track_product_purchased(
        type: purchase.class.to_s,
        product: course.name,
        price: course.price
      )

      expect(analytics).to have_tracked('Purchased product').
        for_user(user).
        with_metadata(
          type: purchase.class.to_s,
          product: course.name,
          price: course.price
        )
    end
  end

  describe '#track_course_enrolled' do
    it 'tracks course enrollment event' do
      course = build_stubbed(:course)

      analytics_instance.track_course_enrolled(
        course: course.name
      )

      expect(analytics).to have_tracked('Enrolled course').
        for_user(user).
        with_metadata(
          course: course.name
        )
    end
  end

  describe '#track_course_completed' do
    it 'tracks course completion event' do
      course = build_stubbed(:course)

      analytics_instance.track_course_completed(
        course: course.name
      )

      expect(analytics).to have_tracked('Completed course').
        for_user(user).
        with_metadata(
          course: course.name
        )
    end
  end

  describe '#track_downloaded' do
    it 'tracks file download event' do
      attachment = build_stubbed(:upload, :attachment)

      analytics_instance.track_downloaded(
        file: attachment.file_filename,
        type: attachment.uploadable_type,
        source: attachment.uploadable_id
      )

      expect(analytics).to have_tracked('Downloaded file').
        for_user(user).
        with_metadata(
          file: attachment.file_filename,
          type: attachment.uploadable_type,
          source: attachment.uploadable_id
        )
    end
  end

  describe '#track_forum_accessed' do
    it 'tracks that the user accessed the forum' do
      analytics_instance.track_forum_accessed

      expect(analytics).to have_tracked('Logged into Forum').for_user(user)
    end
  end
end
