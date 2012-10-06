# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

City.create({ :name => 'Bosanska Krupa', :lat =>  44.883456, :long => 16.152788  })
City.create({ :name => 'Zenica', :lat =>  44.198116, :long => 17.915890  })
City.create({ :name => 'Sarajevo', :lat =>  43.854528, :long => 18.392787 })

User.create({  
  :email => 'test@test.com',
  :password_hash => Digest::SHA256.hexdigest('test'),
  :uuid => UUIDTools::UUID.random_create.to_s,
  :first_name => 'Niko',
  :last_name => 'Nikic',
  :anonymous => false,
  :active => true,
  :role => User::ROLE_USER
})

User.create({  
  :email => 'test2@test.com',
  :password_hash => Digest::SHA256.hexdigest('test'),
  :uuid => UUIDTools::UUID.random_create.to_s,
  :first_name => 'John',
  :last_name => 'Doe',
  :anonymous => false,
  :active => true,
  :role => User::ROLE_USER
})


Category.create({ :name => 'Parkiranje', :color => '44A8D6', :icon => 'parkiranje.png' })
Category.create({ :name => 'Fasade',  :color => 'E23408', :icon => 'fasade.png'  })
Category.create({ :name => 'Okolina', :color => '9ecc3b', :icon => 'okolina.png'  })
Category.create({ :name => 'Rasvjeta', :color => 'ffc80c', :icon => 'rasvjeta.png'  })
Category.create({ :name => 'Putevi',  :color => '683b17', :icon => 'putevi.png'  })
