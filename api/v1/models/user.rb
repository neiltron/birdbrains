require 'mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String, :null => false, :default => ""

  field :first_name, :type => String
  field :last_name, :type => String
  field :nickname, :type => String

  index :email, :unique => true

  has_many :avatars
  has_many :posts

  def name
    nickname || first_name + ' ' + last_name
  end

  def avatar
    avatars.last.image.url
  end
end