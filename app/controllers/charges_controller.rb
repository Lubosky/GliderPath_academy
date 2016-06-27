class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_charge, only: [:show]

  def index
    @charges = policy_scope(Charge).order('created_at DESC')
    authorize @charges
    gon.braintree_client_token = generate_braintree_client_token
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

    def generate_braintree_client_token
      if current_user.braintree_customer?
        Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end

end
