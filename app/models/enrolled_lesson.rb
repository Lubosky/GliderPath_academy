class EnrolledLesson < ApplicationRecord
  belongs_to :student, inverse_of: :enrolled_lessons, class_name: 'User', touch: true
  belongs_to :lesson, inverse_of: :enrolled_lessons

  validates_presence_of :lesson_id, :student_id

  scope :active, -> { with_status :active }
  scope :completed, -> { with_status :completed }

  state_machine :status, initial: :initial do
    state :initial
    state :active
    state :completed

    event :activate do
      transition initial: :active
    end

    event :complete do
      transition active: :completed
    end
  end
end
