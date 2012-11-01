# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@city_bk     = City.create({ :name => 'Bosanska Krupa', :lat =>  44.883456, :long => 16.152788  })
@city_zenica = City.create({ :name => 'Zenica', :lat =>  44.198116, :long => 17.915890  })
@city_sa     = City.create({ :name => 'Sarajevo', :lat =>  43.854528, :long => 18.392787 })

@user1 = User.create({  
  :email => 'test@test.com',
  :password_hash => Digest::SHA256.hexdigest('test'),
  :uuid => UUIDTools::UUID.random_create.to_s,
  :first_name => 'Niko',
  :last_name => 'Nikic',
  :anonymous => false,
  :active => true,
  :role => User::ROLE_USER,
  :locale => 'en'
})

@user2 = User.create({  
  :email => 'test2@test.com',
  :password_hash => Digest::SHA256.hexdigest('test'),
  :uuid => UUIDTools::UUID.random_create.to_s,
  :first_name => 'John',
  :last_name => 'Doe',
  :anonymous => false,
  :active => true,
  :role => User::ROLE_USER,
  :locale => 'bs'
})


@cat_parkiranje = Category.create({ :name => 'Parkiranje', :color => '44A8D6', :icon => 'parkiranje.png' })
@cat_fasade    = Category.create({ :name => 'Fasade',  :color => 'E23408', :icon => 'fasade.png'  })
@cat_okolina   = Category.create({ :name => 'Okolina', :color => '9ecc3b', :icon => 'okolina.png'  })
@cat_rasvjeta  = Category.create({ :name => 'Rasvjeta', :color => 'ffc80c', :icon => 'rasvjeta.png'  })
@cat_putevi    = Category.create({ :name => 'Putevi',  :color => '683b17', :icon => 'putevi.png'  })


#
# e.g.:
#        create_issue(@user1, 'Smece svuda po gradu', 'Smece se nalazi svuda po gradu.', @cat_okolina, @city_sa, ['test/images/1.jpg'])
#
def create_issue(user, title, description, category, city, image_paths)
  lat = city.lat + rand() / 15.0
  long = city.long + rand() / 15.0

  image_ids = []
  image_paths.each do |path|
    image = Image.new()
    image.image = File.new(path)
    image.save!
    image_ids << image.id
  end

  user.create_issue(title, category.id, city.id, description, lat, long, image_ids)
end

require 'lorem'

def random_issues(count)
  images = ['test/images/1.jpg','test/images/2.jpg','test/images/3.jpg','test/images/4.jpg','test/images/5.jpg','test/images/6.jpg','test/images/7.jpg','test/images/8.jpg','test/images/9.jpg']
  categories = [@cat_parkiranje, @cat_fasade, @cat_okolina, @cat_rasvjeta, @cat_putevi]
  users = [@user1, @user2]
  cities = [@city_sa, @city_zenica, @city_bk]

  (1..count).each do |i|
    puts "Crating issue : #{i}"
    create_issue(
      users[Random.new.rand(0..users.length-1)], 
      Lorem::Base.new('words', Random.new.rand(2..5)).output,
      Lorem::Base.new('paragraphs', Random.new.rand(1..3)).output,
      categories[Random.new.rand(0..categories.length-1)],
      cities[Random.new.rand(0..cities.length-1)],
      [images[Random.new.rand(0..images.length-1)]]
    )
  end
end


random_issues(30)
