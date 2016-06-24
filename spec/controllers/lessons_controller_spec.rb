require 'spec_helper'

RSpec.describe LessonsController, type: :controller do

  let(:student) { create(:user) }
  let(:course) { create(:course) }
  let(:section) { create(:section, course: course) }
  let(:lesson) { create(:lesson, section: section, position: 1) }

  describe 'GET #show' do

    before do
      student.confirm
      login student
      student.enroll(course)
      get :show, params: { course_id: course, id: lesson }
    end

    it {
      expect(assigns(:lesson)).to eq(lesson)
      is_expected.to render_template :show
    }
  end

  describe 'POST #complete lesson' do

    before :each do
      student.confirm
      login student
      student.enroll(course)
      enrolled_lesson = create(:enrolled_lesson, lesson: lesson, student: student)
    end

    context 'when completed lesson is not the last lesson' do

      before do
        l2 = create(:lesson, section: section, position: 2)
      end

      it {
        post :complete, params: { course_id: course, id: lesson }
        expect(response).to redirect_to course_lesson_path(course, lesson.next_lesson)
      }

    end

    context 'when completed lesson is last lesson' do

      it {
        post :complete, params: { course_id: course, id: lesson }
        expect(response).to redirect_to course_lesson_path(course, lesson)
      }

    end
  end
end
