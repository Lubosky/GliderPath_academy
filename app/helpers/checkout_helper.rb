module CheckoutHelper
  def checkout_price(resource)
    if resource.stripe_coupon_id.blank?
      single_price(resource)
    else
      comparable_price(resource)
    end
  end

  def comparable_price(resource)
    content_tag(:div, class: 'order-price total') do
      concat content_tag(:span, '£', class: 'currency')
      concat content_tag(:span, resource.coupon.apply(resource.price), class: 'price')
      concat ' '
      concat content_tag(:span, resource.price, class: 'price text-muted', style: 'text-decoration: line-through')
    end
  end

  def single_price(resource)
    content_tag(:div, class: 'order-price total') do
      concat content_tag(:span, '£', class: 'currency')
      concat content_tag(:span, resource.price, class: 'price')
    end
  end

  def subscription_with_coupon(subscription)
    t("subscriptions.discount.#{subscription.coupon.duration}",
      final_price: number_to_currency(subscription.coupon.apply(subscription.price)),
      full_price: number_to_currency(subscription.price),
      duration_in_months: subscription.coupon.duration_in_months)
  end

  def subscription_interval(subscription)
    "#{ subscription.interval_count } #{ subscription.interval_unit }"
  end
end
