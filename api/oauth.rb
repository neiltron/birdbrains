require 'rubygems'
require 'bundler/setup'

%w{
  grape json date
}.each do |lib|
  require lib
end

require_relative 'v1/models/user'

module Birdbrains
  class OAuth < Grape::API
    resource 'oauth' do
      post 'access_token' do
        email = params[:x_auth_username].gsub(/[&]/, '@')
        user = User.where( :email => email).first
        "oauth_token=191074378-1GWuHmFyyKQUKWV6sR6EEzSCdLGnhqyZFBqLagHp&oauth_token_secret=NpCkpRRC5hGEtikMLnQ2eEcEZ0SIVF5Hb2ZgIwmYgdA&user_id=#{user.id.to_s}&screen_name=#{user.nickname}&x_auth_expires=0"
      end
    end
  end
end