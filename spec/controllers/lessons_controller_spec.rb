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

  describe 'POST #complete lesson' do

    context 'when completed lesson is not the last lesson' do

      before do
        u1.confirm
        u2.confirm
        login u1
        login u2
        @course = create(:course, instructor: u1)
        @section = create(:section, course: @course)
        @l1 = create(:lesson, section: @section, position: 1)
        @l2 = create(:lesson, section: @section, position: 2)
        u2.enroll(@course)
        @enrolled_lesson = create(:enrolled_lesson, lesson: @l1, student: u2)
      end

      it {
        post :complete, params: { course_id: @course, id: @l1 }
        expect(response).to redirect_to course_lesson_path(@course, @l1.next_lesson)
      }

    end

    context 'when completed lesson is last lesson' do

      before do
        u1.confirm
        u2.confirm
        login u1
        login u2
        @course = create(:course, instructor: u1)
        @section = create(:section, course: @course)
        @l1 = create(:lesson, section: @section)
        u2.enroll(@course)
        @enrolled_lesson = create(:enrolled_lesson, lesson: @l1, student: u2)
      end

      it {
        post :complete, params: { course_id: @course, id: @l1 }
        expect(response).to redirect_to course_lesson_path(@course, @l1)
      }

    end
  end
end
