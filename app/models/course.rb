class Course < ActiveRecord::Base
  include Concerns::Purchasable
  include Concerns::Sluggable
  include Concerns::Videoable

  belongs_to :instructor, inverse_of: :courses_as_instructor, class_name: 'User'

  validates :name, presence: true
  validates :short_description, presence: true
  validates :description, presence: true
  validates :instructor_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999.99 }

  has_many :enrollments, inverse_of: :courses_as_student, dependent: :destroy, foreign_key: :course_id
  has_many :students, through: :enrollments, class_name: 'User', foreign_key: :student_id
  has_many :sections, -> { order(position: :asc) }, autosave: true, dependent: :destroy, inverse_of: :course
  has_many :lessons, -> { order(position: :asc) }, through: :sections
  has_many :uploads, through: :lessons

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :video, reject_if: :all_blank, allow_destroy: true

  def progress(user)
    Rails.cache.fetch([self, user, __method__]) do
      @course_progress ||= 100 * (lessons_completed_for(user).count.to_f / lessons.count.to_f)
    end
  end

  def content_length
    Rails.cache.fetch([self, lessons, __method__]) do
      lessons.joins(:video).sum(:video_duration)
    end
  end

  def lessons_completed_for(student)
    lessons.lessons_completed_for(student)
  end

  def lessons_remaining_for(student)
    lessons.lessons_remaining_for(student)
  end

  def first_remaining_lesson_for(student)
    lessons_remaining_for(student).first
  end

  private

  def slug_source
    name
  end

  def self.enrolled_courses_for(student)
    joins(:enrollments).where(enrollments: { student: student })
  end

  def self.accessible_courses_for(student)
    joins(:purchases).where(purchases: { purchaser: student }).where.not(id: enrolled_courses_for(student))
  end

  def self.available_courses_for(student)
    where.not(id: accessible_courses_for(student)).where.not(id: enrolled_courses_for(student))
  end
end
