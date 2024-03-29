FactoryGirl.define do

  sequence :code do |n|
    "code#{n}"
  end

  sequence :email do |n|
    "test#{n}@example.com"
  end

  sequence :uuid do |n|
    "uuid_#{n}"
  end

  factory :user do
    first_name 'John'
    last_name 'Doe'
    email
    password '1234abcd'
    password_confirmation '1234abcd'
    confirmed_at 2.hours.ago

    trait :instructor do
      after(:create) { |user| user.add_role(:instructor) }
    end

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :with_stripe do
      stripe_customer_id 'cus12345'
    end

    trait :with_subscription do
      stripe_customer_id 'cus12345'

      after :create do |instance|
        plan = create(:plan)
        create(:subscription, plan: plan, subscriber: instance)
      end
    end

    trait :with_inactive_subscription do
      stripe_customer_id 'cus12345'

      after :create do |instance|
        instance.subscription <<
          create(:inactive_subscription, subscriber: instance)
      end
    end
  end

  factory :coupon do
    transient do
      code
      amount_off 2500
      duration 'forever'
      duration_in_months nil
      percent_off nil
    end

    initialize_with { new(code) }
    to_create {}

    after(:create) do |_, attributes|
      Stripe::Coupon.create(
        id: attributes.code,
        amount_off: attributes.amount_off,
        duration: attributes.duration,
        duration_in_months: attributes.duration_in_months,
        percent_off: attributes.percent_off
      )
    end
  end

  factory :course do
    sequence(:name) { |n| "Course ##{n}" }
    short_description Faker::Lorem.paragraph(2)
    description 'Course description #1'
    price 99.99
    status Course::PUBLISHED
    association :instructor, factory: [:user, :instructor]
  end

  factory :section do
    sequence(:title) { |n| "Section ##{n}" }
    objective Faker::Lorem.paragraph(2)
    position 1
    association :course, factory: :course
  end

  factory :lesson do
    sequence(:title) { |n| "Lesson ##{n}" }
    notes Faker::Lorem.paragraph(2)
    position 1
    association :section, factory: :section
  end

  factory :enrollment do
    association :course, factory: :course
    association :student, factory: :user
  end

  factory :enrolled_lesson do
    association :lesson, factory: :lesson
    association :student, factory: :user
  end

  factory :plan do
    id 1
    stripe_plan_id 'gliderpath_academy_monthly'
    name 'GliderPath Academy - Monthly'
  end

  factory :subscription, aliases: [:active_subscription] do
    association :plan, factory: :plan
    association :subscriber, :with_stripe, factory: :user
    status 'active'

    factory :scheduled_for_cancellation_subscription do
      scheduled_for_cancellation_on { Time.zone.tomorrow }
    end

    factory :canceled_subscription do
      canceled_on { Time.zone.today }
    end
  end

  factory :purchase do
    association :purchaser, factory: :user
    trait :course_purchase do
      association :purchasable, factory: :course
    end
  end

  factory :charge do
    association :user, factory: :user
    product 'GliderPath Academy - Monthly'
    amount '99.0'
    stripe_charge_id '123456789'
  end

  factory :upload do
    uploader_id 1
    uploadable_type 'Lesson'
    uploadable_id 1
  end

  factory :workshop do
    name 'Workshop #1'
    short_description 'Workshop short description'
    notes 'Workshop notes'
    price 9.99
    status Workshop::PUBLISHED
    association :instructor, factory: [:user, :instructor]
    association :video, factory: :video
  end

  factory :video do
    video_url 'https://vimeo.com/132090907/'
  end
end
