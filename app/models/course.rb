class Course < ActiveRecord::Base
  include Concerns::Purchasable
  include Concerns::Videoable

  belongs_to :instructor, inverse_of: :courses_as_instructor, class_name: 'User'

  validates :name, presence: true
  validates :description, presence: true
  validates :instructor_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999.99 }

  has_many :enrollments, inverse_of: :courses_as_student, dependent: :destroy, foreign_key: :course_id
  has_many :students, through: :enrollments, class_name: 'User', foreign_key: :student_id
  has_many :sections, -> { order(position: :asc) }, autosave: true, dependent: :destroy, inverse_of: :course
  has_many :lessons, -> { order(position: :asc) }, through: :sections

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :video, reject_if: :all_blank, allow_destroy: true

  def progress(user)
    100 * (self.lessons.completed.count.to_f / self.lessons.count.to_f)
  end

  def completed_lessons(student)
    @completed_lessons ||= self.lessons.joins(:enrolled_lessons).where(enrolled_lessons: { student_id: student.id, status: 'completed' }).pluck(:id)
  end

  def completed_for(student, lesson)
    self.completed_lessons(student).include?(lesson.id)
  end

end
