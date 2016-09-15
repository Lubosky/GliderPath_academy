class Instructor::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @dashboard = InstructorDashboard.new(current_user)
    authorize @dashboard
  end
end
