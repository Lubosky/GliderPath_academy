require 'spec_helper'

RSpec.describe CoursesController, type: :controller do

  let(:user) { create(:user, :instructor, :admin) }

  before :each do
    user.confirm
    login user
  end

  describe 'GET #index' do
    before do
      get :index
    end
    it {
      is_expected.to respond_with :ok
      is_expected.to render_with_layout :application
      is_expected.to render_template :index
    }
  end

  describe 'GET #show' do

    before do
      @course = create(:course, instructor: user)
      get :show, params: { id: @course }
    end

    it {
      expect(assigns(:course)).to eq(@course)
      is_expected.to render_template :show
    }
  end

  describe 'GET #new' do

    before do
      get :new
    end

    it {
      expect(assigns(:course)).to be_a_new(Course)
      is_expected.to render_template :new
    }
  end

  describe 'GET #create' do

    context 'when new course is invalid' do
      it 'renders the page with error' do
        post :create, params: { course: { name: '', description: '' } }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to match(/^Ooops! We are having trouble creating this course. Please check your form./)

      end
    end

    context 'when new course is valid' do
      it 'creates the course and redirects to courses index page' do
        expect {
          post :create, params: { course: attributes_for(:course) }
        }.to change(Course, :count).by(1)
        expect(response).to redirect_to Course.last
        expect(flash[:success]).to match(/^Course has been successfuly created./)

      end
    end
  end

  describe 'GET #update' do

    before :each do
      @course = create(:course, instructor: user)
    end

    context 'when updated course is invalid' do
      it 'renders the page with error' do
        put :update, params: { id: @course, course: { name: '', description: '', status: Course::PUBLISHED } }
        @course.reload
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to match(/^Sorry! We are having trouble updating this course./)

      end
    end

    context 'when updated course is valid' do
      it 'updates the course' do
        put :update, params: { id: @course, course: { name: 'Updated Course #1', description: 'Updated course description #1', status: Course::PUBLISHED } }
        @course.reload
        expect(@course.name).to eq('Updated Course #1')
        expect(flash[:success]).to match(/^Course has been successfuly updated./)
      end
    end
  end

  describe 'GET #destroy' do

    before do
      @course = create(:course, instructor: user)
    end

    it 'deletes the course and redirects to courses index page' do
      expect {
        delete :destroy, params: { id: @course }
      }.to change(Course,:count).by(-1)
      expect(response).to redirect_to root_path

    end
  end

  describe 'GET #progress' do

    before do
      @course = create(:course)
      @student = create(:user)
      @enrollment = create(:enrollment, student_id: @student.id, course_id: @course.id)
      @student.confirm
      login @student
      get :progress, params: { id: @course }
    end
    it {
      is_expected.to respond_with :ok
      is_expected.to render_template :progress
    }
  end

  describe 'PUT #sort' do
    before do
      course = create(:course)
      put :sort, params: { id: course }
    end
    it {
      is_expected.to respond_with :ok
    }
  end

end
