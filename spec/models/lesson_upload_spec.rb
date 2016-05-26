require 'spec_helper'

describe LessonUpload, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:lesson_id)
      is_expected.to validate_presence_of(:upload_id)

      is_expected.to belong_to :lesson
      is_expected.to belong_to :upload
    end
  end
end
