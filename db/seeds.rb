require 'faker'

## TODO: Assign lists to a user.
## TODO: Assign items to a list.


## Create lists
#
5.times do
  List.create!(
    title: Faker::Lorem.words(3)
  )
end
lists = List.all


## Create tasks
#
10.times do
  Item.create!(
    list: lists.sample,
    name: Faker::Lorem.words(8)
  )
end

puts "Seeding finished."
puts "#{List.count} lists created."
puts "#{Item.count} to-do items created."
