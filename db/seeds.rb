# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## rails console -s (test individual commands in sandbox mode)

def create_users(opts)
  (opts[:times] || 5).times do
    fname  = Faker::Name.first_name
    lname  = Faker::Name.last_name
    domain = opts[:domain] || 'example.com'

    User.create(
      :email    => "#{fname.downcase}.#{lname.downcase}@#{domain}",
      :name     => "#{fname} #{lname}",
      :phone    => Faker::PhoneNumber.cell_phone,
      :role     => (opts[:role]     || 'student'),
      :hireable => (opts[:hireable] || true     ),
      :password => 'acdc',
      :password_confirmation => 'acdc'
    )
  end
end

# Create Students
create_users({times: 20})
# Create Admins
create_users({hireable: false, role: 'admin', times: 4 })

# Create Events
Event.create(
  description: 'Job has been liked.',
  state:       'like'
)
Event.create(
  description: 'Job has been unliked.',
  state:       'start'
)
Event.create(
  description: 'Interview scheduled.',
  state:       'interviewing'
)
Event.create(
  description: 'Interview is pending resolution.',
  state:       'pending'
)
Event.create(
  description: 'User has received offer from company.',
  state:       'offer_received'
)
Event.create(
  description: 'User has discontinued relationship with company.',
  state:       'user_decline'
)
Event.create(
  description: 'Company has passed (for now).',
  state:       'company_decline'
)
Event.create(
  description: 'User has accepted job offer from company.',
  state:       'offer_accepted'
)
Event.create(
  description: 'User has declined job offer from company.',
  state:       'offer_declined'
)
