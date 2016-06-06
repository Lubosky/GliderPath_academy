require 'spec_helper'

RSpec.describe LessonsController, type: :controller do

  let(:u1) { create(:user, :instructor) }
  let(:u2) { create(:user) }

  describe 'GET #show' do

    before do
      u1.confirm
      u2.confirm
      login u1
      login u2
      @course = create(:course, instructor: u1)
      @section = create(:section, course: @course)
      @lesson = create(:lesson, section: @section)
      u2.enroll(@course)
      get :show, params: { course_id: @course, id: @lesson }
    end

    it {
      expect(assigns(:lesson)).to eq(@lesson)
      is_expected.to render_template :show
    }
  end

end
