class Enrollment < ApplicationRecord
  belongs_to :student, inverse_of: :enrollments, class_name: 'User'
  belongs_to :courses_as_student, inverse_of: :enrollments, class_name: 'Course', foreign_key: :course_id

  validates_presence_of :course_id, :student_id
end
