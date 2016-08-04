class ForumSessionPolicy < ApplicationPolicy

  def new?
    return true if user.present?
  end

end
