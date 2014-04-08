# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick


  process :auto_orient # this should go before all other "process" steps

  # auto rotate camera photos
  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  # Choose what kind of storage to use for this uploader:
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  # end

  # Process files as they are uploaded:
  version :issue_full do
    process :resize_to_fit => [600, nil]
  end

  version :issue_thumb do
    process :resize_to_fill => [198, 155]
  end

  version :logo_full do
    process :resize_to_fill => [160, 160]
  end

  version :logo_small do
    process :resize_to_fill => [50, 50]
  end

  #
  # def scale(width, height)
  #   puts "SOMETHING"
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [198, 155]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
