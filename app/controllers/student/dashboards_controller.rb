class Student::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @dashboard = StudentDashboard.new(current_user)
    authorize @dashboard
  end
end
