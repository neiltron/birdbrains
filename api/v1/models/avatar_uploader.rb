require 'carrierwave/mongoid'

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
end