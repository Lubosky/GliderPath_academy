class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_charge, only: [:show]

  def index
    @charges = policy_scope(Charge).order('created_at DESC')
    authorize @charges
    gon.stripe_public_key = STRIPE_PUBLIC_KEY
  end

  def show
    respond_to do |format|
      format.pdf {
        send_data @charge.receipt.render,
          filename: "receipt-#{@charge.receipt_number}.pdf",
          type: 'application/pdf',
          disposition: :attachment
      }
    end
  end

  private

  def set_charge
    @charge = Charge.find(params[:id])
    authorize @charge
  end
end
