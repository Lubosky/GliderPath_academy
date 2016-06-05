require 'spec_helper'

RSpec.describe EnrollmentsController, type: :controller do

  let(:u1) { FactoryGirl.create(:user, :instructor) }
  let(:u2) { FactoryGirl.create(:user) }
  let(:u3) { FactoryGirl.create(:user) }

  describe 'GET #create' do

    before :each do
      u1.confirm
      u2.confirm
      u3.confirm
      login u1
      @course = create(:course, instructor: u1)
      @section = create(:section, course: @course)
      @lesson = create(:lesson, section: @section)
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
