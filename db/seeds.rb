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


## Create a few test users
## ----------------------------------------------
## Drop this in before creating lists so that they
## get included in adding lists to these users.
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

users = User.all


## Create lists
## ----------------------------------------------
#
users.each do |user|
  5.times do
    List.create!(
    user:  user,
    title: Faker::Lorem.sentence(3)
    )
  end
end
lists = List.all


## Create tasks
## ----------------------------------------------
#
lists.each do |list|
  10.times do
    Item.create!(
    list: list,
    name: Faker::Lorem.sentence(8)
    )
  end
end



puts "Seeding finished."
puts "#{List.count} lists created."
puts "#{Item.count} to-do items created."
