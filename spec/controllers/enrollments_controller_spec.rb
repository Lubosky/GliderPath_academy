require 'spec_helper'

RSpec.describe EnrollmentsController, type: :controller do

  let(:u1) { create(:user, :instructor) }
  let(:u2) { create(:user) }
  let(:u3) { create(:user) }
  let(:u4) { create(:user) }

  describe 'GET #create' do

    before do
      u1.confirm
      u2.confirm
      u3.confirm
      u4.confirm
      login u1
      @course = create(:course, instructor: u1)
      @section = create(:section, course: @course)
      @lesson = create(:lesson, section: @section)
      @plan = create(:plan)
      @s1 = build_stubbed(:subscription, subscriber: u2, plan: @plan, status: 'active')
      @s2 = build_stubbed(:subscription, subscriber: u3, plan: @plan, status: 'active')
      @s3 = build_stubbed(:subscription, subscriber: u4, plan: @plan, status: 'cancelled')
    end

    context 'when enrollment is valid' do
      it 'creates the enrollment' do
        login u2
        expect {
          post :create, params: { course_id: @course, student_id: u2.id }
        }.to change(Enrollment, :count).by(1)
        expect(response).to redirect_to course_lesson_path(@course, @lesson)
      end
    end

    context 'when user already enrolled' do
      it 'displays warning about user already enrolled' do
        login u3
        post :create, params: { course_id: @course, student_id: u3.id }
        @course.reload
        expect {
          post :create, params: { course_id: @course, student_id: u3.id }
        }.to change(Enrollment, :count).by(0)
        expect(flash[:warning]).to match t('flash.enrollments.alert')
      end
    end

    context 'when user is not subscribed to the plan nor purchased the item' do
      it 'does not allow the enrollment' do
        login u4
        expect {
          post :create, params: { course_id: @course, student_id: u4.id }
        }.to change(Enrollment, :count).by(0)
      end
    end
  end

end
