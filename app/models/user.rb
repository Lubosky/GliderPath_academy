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

  has_many :courses

  after_create :assign_default_role

  def assign_default_role
    add_role(:student)
  end

end
