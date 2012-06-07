require 'koala'

module FbLoader
	# Use following command to run import from rails console:
	# require "fb_loader/loader" end
	# FbLoader::Loader.new.run
	class Loader
		def initialize
			# initialize a Graph API connection
			@graph = Koala::Facebook::API.new
		end

		# Downloads albums, photos, comments and users from FB to CSV files
		def run()
			# Get first page of albums
			fb_albums = @graph.get_connections("mojeSarajevo","albums")

			# IDs
			num_of_albums = 0
			num_of_photos = 0
			num_of_comments = 0
			num_of_users = 0

			while fb_albums.size > 0
				puts "\tRetrieving #{fb_albums.size} albums..."
				
				# Get albums
				fb_albums.each do |fb_album|
					num_of_albums += 1
					
					# Get album photos
					fb_photos = @graph.get_connections(fb_album['id'],"photos")

					while fb_photos.size > 0
						puts "\t\tRetrieving #{fb_photos.size} photos..."
						fb_photos.each do |fb_photo|
							num_of_photos += 1
							# 0. create new user if one doesn't exist yet 
							# 1. create issue for each photo
							# 2. create attachment with photo URL
							# 3. create issue updates from comments

							# 0. User
							fb_user_id = fb_photo['from']['id']
							user = User.find_by_fb_id(fb_user_id)
							if (user.nil?)
								user = create_user(fb_user_id)
							end

							fb_photo_id = fb_photo['id']
							fb_item = FbItem.find_by_fb_id(fb_photo_id)

							# first time
							if (fb_item.nil?)
								fb_item = FbItem.new
								issue = Issue.new
								attachment = Attachment.new
							else
								issue = Issue.find(fb_item.ssg_id)
								attachment = issue.attachments.first
							end

							# Was this photo updated after the import?
							if (fb_item.fb_updated_at.nil? || fb_item.fb_updated_at < fb_photo['updated_time'])							

								# 1. Issue
								issue.name = "Moj grad, moja sigurnost, moja odgovornost - Issue \##{num_of_photos}"
								issue.description = "This issue is created from \"Moj grad, moja sigurnost, moja odgovornost\" - Facebook ID=#{fb_photo['id']}"
								if (!fb_photo['place'].nil?)
									issue.latitude = fb_photo['place']['location']['latitude']
									issue.longitude = fb_photo['place']['location']['longitude']
								end
								user.issues << issue

								# 2. Attachment
								attachment.file_type = Attachment::JPG
								attachment.name = !fb_photo['name'].nil? ? fb_photo['name'] : "Attachment"
								attachment.URL = fb_photo['source']
								attachment.width = fb_photo['width']
								attachment.height = fb_photo['height']
								attachment.user = user
								
								issue.attachments << attachment

								# 1.1 FBItem for photo
								fb_item.fb_object_type = FbItem::PHOTO
								fb_item.name = fb_photo['name']
								fb_item.fb_id = fb_photo_id
								fb_item.ssg_id = issue.id
								fb_item.fb_created_at = fb_photo['created_time']
								fb_item.fb_updated_at = fb_photo['updated_time']

								# save to DB
								user.save
								issue.save
								attachment.save
								fb_item.save
								
								puts "\t\tPhoto: ID=#{fb_photo_id}"	
							end							

							# retrieve photo comments
							fb_comments = @graph.get_connections(fb_photo_id,"comments")

							while fb_comments.size > 0
								puts "\t\t\tRetriving #{fb_comments.size} comments.."
								
								fb_comments.each do |fb_comment|
									fb_user_id = fb_comment['from']['id']
									fb_comment_id = fb_comment['id']
									
									# Get or create user
									user = User.find_by_fb_id(fb_user_id)
									if (user.nil?)
										user = create_user(fb_user_id)
									end

									# Update existing
									fb_item = FbItem.find_by_fb_id(fb_comment_id)

									# Comments cannot be updated so we're skipping already imported
									if (fb_item.nil?)
										fb_item = FbItem.new
										issue_update = IssueUpdate.new

										# Create issue update from comment
										issue_update.description = fb_comment['message']
										issue_update.user = user
										issue_update.save

										issue.issue_updates << issue_update
										issue.save

										# 1.1 FBItem for comment
										fb_item.fb_object_type = FbItem::COMMENT
										fb_item.name = fb_comment['name']
										fb_item.fb_id = fb_comment_id
										fb_item.ssg_id = issue_update.id
										fb_item.fb_created_at = fb_comment['created_time']
										fb_item.save
									end
								end
								
								# Get next comments
								fb_comments = fb_comments.next_page
							end

						end						
						# Get next set of photos
						fb_photos = fb_photos.next_page
					end

					# Save album to fb_items
					fb_album_id = fb_album['id']
					fb_item = FbItem.find_by_fb_id(fb_album_id)

					if (fb_item.nil?)
						fb_item = FbItem.new
					end

					if (fb_item.fb_updated_at.nil? || fb_item.fb_updated_at < fb_album['updated_time'])
						fb_item.fb_id = fb_album_id
						fb_item.ssg_id = -1
						fb_item.fb_object_type = FbItem::ALBUM
						fb_item.name = fb_album['name']
						fb_item.fb_created_at = fb_album['created_time']
						fb_item.fb_updated_at = fb_album['updated_time']
						fb_item.save
					end
				end
				
				# Get next set of albums
				fb_albums = fb_albums.next_page
			end

			puts "Exported: Albums=#{num_of_albums}, Photos=#{num_of_photos}, Comments=#{num_of_comments}, Users=#{num_of_users}"
		end

		# Creates new user and insert new FB Item
		def create_user(fb_user_id)
			# Get user info from FB
			fb_user = @graph.get_object(fb_user_id)

			# create new user
			user = User.new
			user.fb_id = fb_user['id']
			user.last_name = fb_user['last_name']
			user.first_name = fb_user['first_name']
			user.locale = fb_user['locale']
			user.gender = fb_user['gender']
			user.active = false
			user.role = User::ROLE_USER
			user.save

			# add FB Item to DB
			fb_item = FbItem.new
			fb_item.fb_id = user.fb_id
			fb_item.ssg_id = user.id
			fb_item.name = fb_user['name']
			fb_item.fb_object_type = FbItem::USER
			fb_item.save

			return user
		end
	end
end