class Lesson < ApplicationRecord
  include Concerns::Sluggable
  include Concerns::Uploadable
  include Concerns::Videoable

  validates :title, presence: true

  belongs_to :section, inverse_of: :lessons, foreign_key: :section_id, touch: true

  has_many :enrolled_lessons, inverse_of: :lesson, dependent: :destroy, foreign_key: :lesson_id
  has_many :students, through: :enrolled_lessons, class_name: 'User', foreign_key: :student_id

  has_one :course, through: :section

  accepts_nested_attributes_for :uploads, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :video, reject_if: :all_blank, allow_destroy: true

  before_save :generate_slug, on: :create
  after_save :set_position, on: :create

  def next_lesson
    lessons = course.lessons.order('position ASC')
    if position >= lessons.first.position + lessons.size - 1
      return nil
    else
      return lessons.find_by_position(position + 1)
    end
  end

  def completed?(student)
    Lesson.lessons_completed_for(student).include? id
  end

  private

  def slug_source
    title
  end

  def set_position
    lesson_ids = course.lesson_ids.reject(&:blank?).map(&:to_i)

    lesson_ids.each_with_index do |lesson_id, index|
      Lesson.where(id: lesson_id).update_all(position: index + 1)
    end
  end

  def self.lessons_completed_for(student)
    joins(:enrolled_lessons)
    .where(enrolled_lessons: { status: 'completed', student_id: student.id })
    .pluck(:id)
  end

  def self.lessons_remaining_for(student)
    where.not(id: Lesson.lessons_completed_for(student))
    .pluck(:id)
  end

  def self.video_cache_key
    Video.where(videoable_type: model_name.name.humanize).all.cache_key
  end
end
