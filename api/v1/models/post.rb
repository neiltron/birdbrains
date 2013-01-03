require 'mongoid'
require 'boxer'

class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :text, :type => String

  belongs_to :user
  has_many :assets
end