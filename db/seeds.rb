def create_for message, array, parent=nil, &block
  print "\033[1m->\033[0m #{message}"
  if array.is_a?(Array)
    array.each do |i|
      block.call(parent, i)
      print "\033[32m.\033[0m"
    end
  else
    array.to_i.times do |i|
      block.call(parent, i)
      print '.'
    end
  end
  print "\n"
end

def password
  ENV.fetch('SEED_PASSWORD', 'p@ssword')
end

unless Role.any?
  create_for 'roles', Role::NAMES do |_, name|
    Role.create! name: name
  end
end

unless Plan.any?
  create_for 'plans', Plan::NAMES do |_, plan_id|
    Plan.create! stripe_plan_id: plan_id, name: 'GliderPath Academy - Monthly'
  end
end

case Rails.env
when 'development'

  create_for 'students', [
    30.times.map do
      {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.now
      }
    end
  ] do |_, params|
    u = User.create(params)
  end

  create_for 'instructors', User.all.sample(5) do |_, user|
    user.add_role :instructor
  end

  create_for 'admins', [
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: 'admin@example.com',
      password: password,
      password_confirmation: password,
      confirmed_at: Time.now
    }
  ] do |_, params|
    u = User.create(params)
    u.add_role :admin
  end

  create_for 'courses', [
    9.times.map do
      {
        name: Faker::Book.title,
        short_description: Faker::Lorem.paragraph(2),
        description: Faker::ChuckNorris.fact,
        price: Faker::Commerce.price,
        instructor_id: User.with_role('instructor').map { |instructor| instructor.id }.sample,
        sections_attributes: rand(1..5).times.map do |section|
          {
            title: Faker::Hipster.sentence,
            objective: Faker::Lorem.paragraph,
            lessons_attributes: rand(1..9).times.map do |lesson|
              {
                title: Faker::Hipster.sentence,
                notes: Faker::Lorem.paragraph(2)
              }
            end
          }
        end
      }
    end
  ] do |_, params|
    course = Course.create(params)
  end

  create_for 'workshops', [
    18.times.map do
      {
        name: Faker::Book.title,
        short_description: Faker::Lorem.paragraph(2),
        notes: Faker::ChuckNorris.fact,
        price: Faker::Commerce.price,
        instructor_id: User.with_role('instructor').map { |instructor| instructor.id }.sample,
      }
    end
  ] do |_, params|
    workshop = Workshop.create(params)
  end
end
