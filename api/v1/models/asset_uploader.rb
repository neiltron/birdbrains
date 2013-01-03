require 'carrierwave'

class AssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
end