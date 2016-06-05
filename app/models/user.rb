class User < ApplicationRecord
  rolify
  devise  :confirmable,
          :database_authenticatable,
          :lockable,
          :registerable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable
          # :timeoutable, :omniauthable

  validates_presence_of :first_name, :last_name

  has_many :courses_as_instructor, inverse_of: :instructor, class_name: 'Course', foreign_key: :instructor_id
  has_many :uploads, inverse_of: :user

  after_create :assign_default_role

  def assign_default_role
    add_role(:student)
  end

  private

    def self.current
      RequestStore.store[:current_user]
    end

    def self.current=(user)
      RequestStore.store[:current_user] = user
    end

end
