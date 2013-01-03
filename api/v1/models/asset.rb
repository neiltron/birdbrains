require 'mongoid'
require 'carrierwave'

class Asset
  include Mongoid::Document
  extend CarrierWave::Mount

  mount_uploader :file, AssetUploader, :mount_on => :filename

  belongs_to :post
end