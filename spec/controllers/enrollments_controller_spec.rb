require 'spec_helper'

RSpec.describe EnrollmentsController, type: :controller do

  let(:u1) { create(:user, :instructor) }
  let(:u2) { create(:user) }
  let(:u3) { create(:user) }

  describe 'GET #create' do

    before :each do
      u1.confirm
      u2.confirm
      u3.confirm
      login u1
      login u2
      login u3
      @course = create(:course, instructor: u1)
      @section = create(:section, course: @course)
      @lesson = create(:lesson, section: @section)
      @plan = create(:plan)
      @s1 = create(:subscription, subscriber: u2, plan: @plan, status: 'active')
      @s2 = create(:subscription, subscriber: u3, plan: @plan, status: 'active')
    end

    context 'when enrollment is valid' do
      it 'creates the enrollment' do
        expect {
          post :create, params: { course_id: @course.id, student_id: u2.id }
        }.to change(Enrollment, :count).by(1)
      end
    end

    context 'when enrollment is invalid' do
      it 'displays warning and redirects back' do
        post :create, params: { course_id: @course.id, student_id: u3.id }
        @course.reload
        expect {
          post :create, params: { course_id: @course.id, student_id: u3.id }
        }.to change(Enrollment, :count).by(0)
        expect(flash[:warning]).to match t('flash.enrollments.alert')
      end
    end
  end

end
