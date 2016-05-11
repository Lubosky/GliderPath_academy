FactoryGirl.define do

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
end
