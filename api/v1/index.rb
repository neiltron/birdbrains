require 'rubygems'
require 'bundler/setup'

#require_relative 'helpers'

%w{
  grape json date boxer carrierwave fog
}.each do |lib|
  require lib
end

require_relative 'models/asset_uploader'
require_relative 'models/asset'
require_relative 'models/avatar_uploader'
require_relative 'models/avatar'
require_relative 'models/post'
require_relative 'models/user'

require 'pp'

module Birdbrains
  class API < Grape::API
    version '1'

    resource 'statuses' do
      get 'home_timeline' do
        # => possible params:
        # =>   count
        # =>   since_id. created_at after passed id
        # =>   max_id. created_at before passed id
        # =>   page
        # =>   trim user
        # =>   include_rts
        # =>   include_entities
        # =>   exclude replies
        # =>   contributor details

        max_post = Post.where( :_id => params[:max_id] ).first

        posts = Post.all
        posts = posts.where( :created_at.lt => max_post.created_at ) unless max_post.nil?

        posts.limit(params[:count] || 100).order_by([[ :created_at, :desc ]]).map { |post| Boxer.ship(:tweet, post) }
      end

      get 'user_timeline' do
        user = User.where( :_id => params[:user_id] ).first
        max_post = user.posts.where( :_id => params[:max_id] ).first

        posts = user.posts.all
        posts = posts.where( :created_at.lt => max_post.created_at ) unless max_post.nil?

        posts.limit(params[:count] || 100).order_by([[ :created_at, :desc ]]).map { |post| Boxer.ship(:tweet, post) }
      end
    end
  end
end

Boxer.box(:tweet) do |box, post|
  text = [post.title, post.text].join("\n")
  urls = []

  if post.assets.count > 0
    text += "\n"

    post.assets.each do |asset|
      text += "\n"

      urls.push :display_url => asset.filename, :url => asset.file, :indices => [text.length, (text.length + filename.length)], :expanded_url => nil

      text += filename
    end
  end

  box.view(:base) do
    {
      "coordinates" => nil,
      "favorited" => false,
      "created_at" => post.created_at.strftime('%a %b %d %I:%M:%S +0000 %Y'),
      "truncated" => false,
      "entities" => {
        "urls" => urls,
        "hashtags" => [],
        "user_mentions" => []
      },
      "text" => text,
      "annotations" => nil,
      "contributors" => nil,
      "id" => post.id.to_s,
      "geo" => nil,
      "in_reply_to_user_id" => nil,
      "place" => nil,
      "in_reply_to_screen_name" => nil,
      "user" => {
        "name" => post.user.nickname,
        "profile_sidebar_border_color" => "AD0066",
        "profile_background_tile" => false,
        "profile_sidebar_fill_color" => "AD0066",
        "created_at" => post.user.created_at.strftime('%a %b %d %I:%M:%S +0000 %Y'),
        "profile_image_url" => '',
        "location" => '',
        "profile_link_color" => "FF8500",
        "follow_request_sent" => false,
        "url" => '',
        "favourites_count" => 0,
        "contributors_enabled" => false,
        "utc_offset" => -28800,
        "id" => post.user.id.to_s,
        "profile_use_background_image" => true,
        "profile_text_color" => "000000",
        "protected" => false,
        "followers_count" => 0,
        "lang" => "en",
        "notifications" => true,
        "time_zone" => "Pacific Time (US & Canada)",
        "verified" => false,
        "profile_background_color" => "cfe8f6",
        "geo_enabled" => true,
        "description" => '',
        "friends_count" => 0,
        "statuses_count" => post.user.posts.count,
        "profile_background_image_url" => "http://a3.twimg.com/profile_background_images/3368753/twitter_flowerbig.gif",
        "following" => true,
        "screen_name" => post.user.nickname
      },
      "source" => "web",
      "in_reply_to_status_id" => nil
    }
  end
end