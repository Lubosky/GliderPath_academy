VALID_CREDIT_CARD_NUMBER = '4242424242424242'
INVALID_CREDIT_CARD_NUMBER = 'invalid credit card number'

module CheckoutHelper
  def fill_in_name_and_email
    fill_in 'user_first_name', with: 'John'
    fill_in 'user_last_name', with: 'Doe'
    fill_in 'user_email', with: 'test@example.com', match: :first
  end

  def fill_out_credit_card_form_with_valid_credit_card
    fill_out_credit_card_form_with(VALID_CREDIT_CARD_NUMBER)
  end

  def fill_out_credit_card_form_with_invalid_credit_card
    fill_out_credit_card_form_with(INVALID_CREDIT_CARD_NUMBER)
  end

  def fill_out_credit_card_form_with(credit_card_number)
    credit_card_expires_on = Time.current.advance(years: 1)
    month_selection = credit_card_expires_on.strftime('%-m - %B')
    year_selection = credit_card_expires_on.strftime('%Y')

    fill_in 'card_number', with: credit_card_number
    select month_selection, from: 'date_month'
    select year_selection, from: 'date_year'
    fill_in 'card_code', with: '333'
    click_button t('button.subscription.new')
  end

  def fill_out_account_creation_form_as(user)
    fill_out_account_creation_form(
      user.slice(:first_name, :last_name, :email, :password)
    )
  end

  def fill_out_account_creation_form(user_attributes={})
    user = build(:user, user_attributes)
    fill_in 'user_first_name', with: 'John'
    fill_in 'user_last_name', with: 'Doe'
    fill_in 'user_email', with: Faker::Internet.email, match: :first
    fill_in 'user_password', with: 'secure123!@#', match: :first
    click_button t('button.account.create')
  end
end
