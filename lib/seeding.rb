require 'lorem'

class Seeding

	#
	# e.g.:
	#     create_issue(@user1, 'Smece svuda po gradu', 'Smece se nalazi svuda po gradu.', @cat_okolina, @city_sa, ['test/images/1.jpg'])
	#
	def self.create_issue(user, title, description, category, city, image_paths)
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

	def self.random_issues(count)
	  images = ['test/images/1.jpg','test/images/2.jpg','test/images/3.jpg','test/images/4.jpg','test/images/5.jpg','test/images/6.jpg','test/images/7.jpg','test/images/8.jpg','test/images/9.jpg']
	  categories = Category.all
	  users = User.all
	  cities = City.all

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

end
