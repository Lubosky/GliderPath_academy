class Section < ApplicationRecord
  CACHE_KEY_BASE = ['models', model_name.name.humanize.downcase].freeze

  validates :title, presence: true
  validates :position, presence: true,
                       uniqueness: { scope: :course },
                       numericality: { only_integer: true, greater_than: 0 }

  belongs_to :course, inverse_of: :sections, foreign_key: :course_id, touch: true
  has_many :lessons, -> { order(position: :asc) }, autosave: true, dependent: :destroy, inverse_of: :section

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  before_validation :set_position, on: :create

  protected

  def set_position
    if position.to_i.zero?
      course.sections.each_with_index do |section, index|
        section.update_attribute(:position, index + 1)
      end
    end
  end

  def self.lesson_count
    Rails.cache.fetch([CACHE_KEY_BASE, __method__, Lesson.all.cache_key]) do
      joins(:lessons).group('sections.id').count
    end
  end

  def self.completed_lessons_count_for(student)
    joins(lessons: :enrolled_lessons)
    .where(enrolled_lessons: { status: 'completed', student_id: student.id })
    .group('sections.id')
    .count
  end
end
