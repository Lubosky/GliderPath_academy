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

case Rails.env
when 'development'

  create_for 'students', [
    30.times.map do
      { first_name: Faker::Name.first_name,
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
    { first_name: Faker::Name.first_name,
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

end
