class User < ApplicationRecord
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

end
