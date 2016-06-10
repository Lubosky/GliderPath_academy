class Course < ActiveRecord::Base
  belongs_to :instructor, inverse_of: :courses_as_instructor, class_name: 'User'

  validates :name, presence: true
  validates :description, presence: true
  validates :instructor_id, presence: true

  has_many :enrollments, inverse_of: :courses_as_student, dependent: :destroy, foreign_key: :course_id
  has_many :students, through: :enrollments, class_name: 'User', foreign_key: :student_id
  has_many :sections, -> { order(position: :asc) }, autosave: true, dependent: :destroy, inverse_of: :course
  has_many :lessons, -> { order(position: :asc) }, through: :sections

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  def progress(user)
    100 * (self.lessons.completed.count.to_f / self.lessons.count.to_f)
  end

end
