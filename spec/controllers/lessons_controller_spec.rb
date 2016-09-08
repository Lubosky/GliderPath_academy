require 'spec_helper'

RSpec.describe LessonsController, type: :controller do

  let(:course) { create(:course) }
  let(:section) { create(:section, course: course) }
  let(:lesson) { create(:lesson, section: section, position: 1) }

  describe 'GET #show' do
    context 'when student has enrolled to the course' do
      it 'gets the requested lesson' do
        student = create(:user, :with_subscription)
        confirm_and_login_user_with(student)
        allow(student).to receive(:enrolled?).with(course).and_return(true)

        get :show, params: { course_id: course, id: lesson }

        expect(assigns(:lesson)).to eq(lesson)
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST #complete lesson' do
    context 'when completed lesson is not the last lesson' do
      it 'redirects to the next lesson within a course' do
        student = create(:user, :with_subscription)
        confirm_and_login_user_with(student)
        allow(student).to receive(:enrolled?).with(course).and_return(true)
        create(:enrolled_lesson, lesson: lesson, student: student)
        create(:lesson, section: section, position: 2)

        post :complete, params: { course_id: course, id: lesson }

        expect(response).to redirect_to course_lesson_path(course, lesson.next_lesson)
      end
    end

    context 'when completed lesson is last lesson' do
      it 'redirects to the next lesson within a course' do
        student = create(:user, :with_subscription)
        lesson = create(:lesson, section: section)
        confirm_and_login_user_with(student)
        allow(student).to receive(:enrolled?).with(course).and_return(true)
        create(:enrolled_lesson, lesson: lesson, student: student)

        post :complete, params: { course_id: course, id: lesson }

        expect(response).to redirect_to course_lesson_path(course, lesson)
      end
    end
  end

  describe 'GET #preview' do
    context 'when user is course instructor or admin' do
      it 'gets the requested lesson' do
        admin = create(:user, :admin)
        confirm_and_login_user_with(admin)

        get :preview, params: { course_id: course, id: lesson }

        expect(assigns(:lesson)).to eq(lesson)
        expect(response).to render_template(:show)
      end
    end
  end

  def confirm_and_login_user_with(user)
    user.confirm
    login user
  end
end
