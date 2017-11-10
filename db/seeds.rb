# User.create(f_name: 'Bobby', l_name: 'McBobberson')
require 'faker'

user = User.create(username: 'admin', password: '12345', fname: 'Jane', lname: 'McBobberson')

20.times do
  Message.create(
    body: Faker::RickAndMorty.quote,
    user_id: user.id
    )
end
