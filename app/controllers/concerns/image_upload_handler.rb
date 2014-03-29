module Concerns::ImageUploadHandler
  def image_ids
    image_count = params[:image_count].to_i
    (0..(image_count - 1)).map { |i| params["image_#{i}"] }
  end
end
