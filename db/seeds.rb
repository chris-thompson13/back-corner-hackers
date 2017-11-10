# Put data creation code here
# Initiate the data by running 'rake db:seed'
# in the command line after running migrations (rake db:migrate)

# e.g.
# User.create(f_name: 'Bobby', l_name: 'McBobberson')
require 'faker'

20.times do
  Message.create(
    title: Faker::RickAndMorty.character,
    body: Faker::RickAndMorty.quote

  )
end
