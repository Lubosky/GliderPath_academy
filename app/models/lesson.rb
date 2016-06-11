class Lesson < ApplicationRecord
  include Concerns::Videoable

  validates :title, presence: true

  belongs_to :section, inverse_of: :lessons, foreign_key: :section_id

  has_many :enrolled_lessons, inverse_of: :lesson, dependent: :destroy, foreign_key: :lesson_id
  has_many :students, through: :enrolled_lessons, class_name: 'User', foreign_key: :student_id
  has_many :lesson_uploads, dependent: :destroy, inverse_of: :lesson
  has_many :uploads, through: :lesson_uploads

  has_one :course, through: :section

  accepts_nested_attributes_for :lesson_uploads, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :video, reject_if: :all_blank, allow_destroy: true
  accepts_attachments_for :uploads, append: true

  after_save :set_position, on: :create

  scope :completed, -> { joins(:enrolled_lessons).where('enrolled_lessons.status = ? AND student_id = ?', 'completed', User.current.id) }
  scope :active, -> { joins(:enrolled_lessons).where('enrolled_lessons.status = ? AND student_id = ?', 'active', User.current.id) }

  def next_lesson
    lessons = self.course.lessons.order('position ASC')
    if self.position >= lessons.first.position + lessons.size - 1
      return nil
    else
      return lessons.find_by_position(self.position + 1)
    end
  end

  def completed?(user)
    self.enrolled_lessons.completed.where(student_id: user.id).present?
  end

  def active?(user)
    self.enrolled_lessons.active.where(student_id: user.id).present?
  end

  protected

    def set_position
      i = 0
      if self.position.to_i.zero?
        self.course.lessons.each_with_index { |n, i| n.update_attribute( :position, i + 1 ) }
      end
    end

end
