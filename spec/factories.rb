require 'refile/file_double'

FactoryGirl.define do

  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    first_name 'John'
    last_name 'Doe'
    email
    password '1234abcd'
    password_confirmation '1234abcd'
    confirmed_at 2.hours.ago

    trait :instructor do
      after(:create) {|user| user.add_role(:instructor)}
    end
    trait :admin do
      after(:create) {|user| user.add_role(:admin)}
    end

  end

  factory :course do
    name 'Course #1'
    short_description Faker::Lorem.paragraph(2)
    description 'Course description #1'
    price 99.99
    association :instructor, factory: [ :user, :instructor ]
  end

  factory :section do
    title 'Section #1'
    objective Faker::Lorem.paragraph(2)
    position 1
    association :course, factory: :course
  end

  factory :lesson do
    title 'Lesson #1'
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
    braintree_plan_id 'gliderpath_academy_monthly'
    name 'GliderPath Academy - Monthly'
  end

  factory :subscription do
    association :plan, factory: :plan
    association :subscriber, factory: :user
    status 'active'
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
    braintree_transaction_id '123456789'
    trait :paypal do
      braintree_payment_method 'PayPalAccount'
      paypal_email email
    end

    trait :credit_card do
      braintree_payment_method 'CreditCard'
      card_type 'Visa'
      card_exp_month '09'
      card_exp_year '2027'
      card_last4 '4242'
    end
  end

  factory :upload do
    trait :refile do
      file Refile::FileDouble.new('yoda', Rails.root.to_s + 'spec/support/images/yoda.jpg', content_type: 'image/jpg')
    end

    trait :attachment do
      file_id '999'
      file_filename 'unicorn.png'
      file_size 999
      file_content_type 'image/png'
      uploader_id 1
      uploadable_type 'Lesson'
      uploadable_id 1
    end
  end

  factory :workshop do
    name 'Workshop #1'
    short_description 'Workshop short description'
    notes 'Workshop notes'
    price 9.99
    association :instructor, factory: [ :user, :instructor ]
    association :video, factory: :video
  end

  factory :video do
    video_url 'https://vimeo.com/132090907/'
  end
end
