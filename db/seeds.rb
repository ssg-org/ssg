# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create({  
  :email => 'test@test.com',
  :password_hash => Digest::SHA256.hexdigest('test'),
  :first_name => 'Niko',
  :last_name => 'Nikic',
  :anonymous => false,
  :active => true,
  :role => User::ROLE_USER
})

User.create({  
  :email => 'test2@test.com',
  :password_hash => Digest::SHA256.hexdigest('test'),
  :first_name => 'John',
  :last_name => 'Doe',
  :anonymous => false,
  :active => true,
  :role => User::ROLE_USER
})


Category.create({ :name => 'Parkiranje' })
Category.create({ :name => 'Fasade' })
Category.create({ :name => 'Okolina' })
Category.create({ :name => 'Rasvjeta' })
Category.create({ :name => 'Putevi' })
