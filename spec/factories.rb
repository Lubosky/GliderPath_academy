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
  end

  factory :section do
    title 'Section #1'
    objective 'Section description #1'
  end

  factory :lesson do
    title 'Lesson #1'
    notes 'Lesson description #1'
  end

  factory :upload do
    file Refile::FileDouble.new('yoda', Rails.root.to_s + 'spec/support/images/yoda.jpg', content_type: 'image/jpg')
  end
end
