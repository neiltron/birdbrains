require 'mongoid'

class Avatar
  include Mongoid::Document
  extend CarrierWave::Mount

  mount_uploader :image, AvatarUploader, :mount_on => :filename

  belongs_to :user
end