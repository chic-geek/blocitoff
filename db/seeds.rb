require 'faker'

## TODO: Assign lists to a user.
## TODO: Assign items to a list.


## Create users
## ----------------------------------------------
#
3.times do
  user = User.new(
    name:     Faker::Name.name,
    email:    Faker::Internet.email,
    password: Faker::Lorem.characters(10)
  )
  user.skip_confirmation!
  user.save!
end
users = User.all


## Create lists
## ----------------------------------------------
#
5.times do
  List.create!(
    user:  users.sample,
    title: Faker::Lorem.sentence(3)
  )
end
lists = List.all


## Create tasks
## ----------------------------------------------
#
10.times do
  Item.create!(
    list: lists.sample,
    name: Faker::Lorem.sentence(8)
  )
end


## Create a few test users
## ----------------------------------------------
#
memberone = User.new(
  name:     'Member One',
  email:    'memberone@test.com',
  password: 'memberone'
)
memberone.skip_confirmation!
memberone.save

membertwo = User.new(
  name:     'Member Two',
  email:   'membertwo@test.com',
  password: 'membertwo'
)
membertwo.skip_confirmation!
membertwo.save


puts "Seeding finished."
puts "#{List.count} lists created."
puts "#{Item.count} to-do items created."
