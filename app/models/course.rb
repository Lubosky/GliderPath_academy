class Course < ActiveRecord::Base
  include Concerns::Publishable
  include Concerns::Purchasable
  include Concerns::Sluggable
  include Concerns::Videoable

  CACHE_KEY_BASE = ['models', model_name.name.humanize.downcase].freeze

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
    @course_progress ||=
      100 * (Course.completed_lessons_count_for(user)[id].to_f / Course.lesson_count[id].to_f)
  end

  def modules
    sections.includes(lessons: :video)
  end

  def lessons_remaining_for(student)
    lessons.lessons_remaining_for(student)
  end

  def first_remaining_lesson_for(student)
    lesson = Lesson.find_by_id(lessons_remaining_for(student).first)
    lesson
  end

  private

  def slug_source
    name
  end

  def self.ordered
    order(created_at: :desc)
  end

  def self.lesson_count
    Rails.cache.fetch([CACHE_KEY_BASE, __method__, Lesson.all.cache_key]) do
      joins(:lessons)
      .group('courses.id')
      .count
    end
  end

  def self.content_length
    Rails.cache.fetch([CACHE_KEY_BASE, __method__, Lesson.video_cache_key]) do
      joins(lessons: :video)
      .group('courses.id')
      .sum(:video_duration)
    end
  end

  def self.completed_lessons_count_for(student)
    joins(lessons: :enrolled_lessons)
    .where(enrolled_lessons: { status: 'completed', student_id: student.id })
    .group('courses.id')
    .count
  end
end
