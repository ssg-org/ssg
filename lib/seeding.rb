require 'lorem'
require 'open-uri'

class Seeding

	EXTENSIONS = ['.jpg','.jpeg','.gif','.png','.bmp']
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

	 	  extension = EXTENSIONS.select { |e| path.include? e }

	 	  return if extension.nil? || extension.first.nil?

	 	  begin
		    tempfile = Tempfile.new(['temp',extension.first]).tap do |file|
				  file.binmode # must be in binary mode
				  file.write open(path).read
				  file.rewind
				end
			rescue Exception => e
				puts "Error reading file #{e.message}"
				return
			end


	    image.image = tempfile
	    #image.image = File.new(path)
	    image.save!
	    image_ids << image.id
	  end

	  user.create_issue_seed(title, category.id, city.id, description, lat, long, image_ids, 
	  	Random.new.rand(1..5),
	  	random_date(),
	  	Random.new.rand(0..100),
	  	Random.new.rand(0..1000),
	  	Random.new.rand(0..50),
	  	Random.new.rand(0..150)
	  	)
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
	      RandomImages::Images.get(Random.new.rand(1..3))
	      #[images[Random.new.rand(0..images.length-1)]]
	    )
	  end
	end

	private

	def self.random_date()
		date2 = DateTime.now
		date1 = DateTime.now - 1.month
		Time.at((date2.to_f - date1.to_f)*rand + date1.to_f)
	end

end
