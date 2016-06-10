class Section < ApplicationRecord
  validates :title, presence: true
  validates :position, presence: true,
                       uniqueness: { scope: :course },
                       numericality: { only_integer: true, greater_than: 0 }

  belongs_to :course, inverse_of: :sections, foreign_key: :course_id
  has_many :lessons, autosave: true, dependent: :destroy, inverse_of: :section

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  before_validation :set_position, on: :create

  def progress(user)
    100 * (self.lessons.completed.count.to_f / self.lessons.count.to_f)
  end

  protected

    def set_position
      i = 0
      if self.position.to_i.zero?
        self.course.sections.each_with_index { |n, i| n.update_attribute( :position, i + 1 ) }
      end
    end

end
