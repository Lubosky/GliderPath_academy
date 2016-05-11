require 'spec_helper'

RSpec.describe LessonsController, type: :controller do

  describe 'GET #show' do

    before do
      @course = create(:course)
      @section = create(:section, course: @course)
      @lesson = create(:lesson, section: @section)
      get :show, params: { course_id: @course, id: @lesson }
    end

    it {
      expect(assigns(:lesson)).to eq(@lesson)
      is_expected.to render_template :show
    }
  end

end
