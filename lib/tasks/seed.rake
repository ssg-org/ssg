require 'seeding'

namespace :seed do
	desc "Seed users and issues"
	task :issues, [:count_of_users,:count_of_issues] => [:environment]  do |t, args|

		if (args.count_of_users.blank? || args.count_of_users.blank?)
			abort "Usage: rake seed:issues[count_of_users,count_of_issues]"
		end

		(1..args.count_of_users.to_i).each do |i|
			puts "Creating user : #{i}"
			User.create({  
			  :email => "test#{i}@test.com",
			  :username => "test#{i}",
			  :password_hash => Digest::SHA256.hexdigest('test'),
			  :uuid => UUIDTools::UUID.random_create.to_s,
			  :first_name => "Testni_#{i}",
			  :last_name => 'Doe',
			  :anonymous => false,
			  :active => true,
			  :role => User::ROLE_USER,
			  :locale => 'en'
			})
		end

		Seeding::random_issues(args.count_of_issues.to_i)
	end
end