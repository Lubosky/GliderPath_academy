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
    @course_progress ||= 100 * (self.lessons_completed_for(user).count.to_f / self.lessons.count.to_f)
  end

  def lessons_completed_for(student)
    self.lessons.lessons_completed_for(student)
  end

  def lessons_remaining_for(student)
    self.lessons.lessons_remaining_for(student)
  end

  def lesson_completed_for(student, lesson)
    self.lessons_completed_for(student).include?(lesson.id)
  end

  def first_remaining_lesson_for(student)
    self.lessons_remaining_for(student).first
  end

  private

    def self.enrolled_courses_for(student)
      self.joins(:enrollments).where(enrollments: { student: student })
    end

    def self.accessible_courses_for(student)
      self.joins(:purchases).where(purchases: { purchaser: student }).where.not(id: self.enrolled_courses_for(student))
    end

    def self.available_courses_for(student)
      self.where.not(id: self.accessible_courses_for(student)).where.not(id: self.enrolled_courses_for(student))
    end

end
