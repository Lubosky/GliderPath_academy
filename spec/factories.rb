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
    description 'Course description #1'
    association :instructor, factory: [ :user, :instructor ]
  end

  factory :section do
    title 'Section #1'
    objective 'Section description #1'
    position 1
    association :course, factory: :course
  end

  factory :lesson do
    title 'Lesson #1'
    notes 'Lesson description #1'
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

  factory :upload do
    file Refile::FileDouble.new('yoda', Rails.root.to_s + 'spec/support/images/yoda.jpg', content_type: 'image/jpg')
  end
end
