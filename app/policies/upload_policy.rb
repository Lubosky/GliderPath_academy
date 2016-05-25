class UploadPolicy < ApplicationPolicy

  def download?
    return true if user.present?
  end

end
