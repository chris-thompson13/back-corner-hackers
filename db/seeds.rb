# User.create(f_name: 'Bobby', l_name: 'McBobberson')
require 'faker'

user = User.create(username: 'admin', password: '12345', fname: 'Jane', lname: 'McBobberson')
20.times do
  Message.create(
    body: Faker::RickAndMorty.quote,
    user_id: user.id
    )
end

20.times do
  user = User.create(
    username: Faker::Internet.user_name,
    password: '12345',
    fname: Faker::Name.first_name,
    lname: Faker::Name.last_name
    )
   20.times do
     Message.create(
       body: Faker::RickAndMorty.quote,
       user_id: user.id
     )
   end
 end
