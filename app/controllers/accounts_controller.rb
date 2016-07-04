class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    authorize :account
  end

  def edit
    authorize :account
  end

  def update_account
    authorize :account
    if @user.update_attributes(account_params)
      flash[:success] = t('flash.account.update.success')
      redirect_to account_path
    else
      flash[:alert] = t('flash.account.update.error')
      render :edit
    end
  end

  private

    def account_params
      params.require(:user).permit(:avatar, :first_name, :last_name)
    end

    def set_user
      @user = current_user
    end

end
