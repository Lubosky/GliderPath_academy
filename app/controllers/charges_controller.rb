class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_charge, only: [:show]

  def index
    @charges = policy_scope(Charge).order('created_at DESC')
    authorize @charges
  end

  def show
  end

  private

    def set_charge
      @charge = Charge.find(params[:id])
      authorize @charge
    end

end
