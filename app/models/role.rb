class Role < ApplicationRecord

  NAMES = %w( admin instructor student )

  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource, polymorphic: true, optional: true

  validates :name, presence: true, uniqueness: true, inclusion: NAMES
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify
end
