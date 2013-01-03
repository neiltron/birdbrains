#!/usr/bin/env ruby
# encoding: UTF-8

$0 = 'birdbrains'
$LOAD_PATH.unshift ::File.dirname(__FILE__)

ENV['RACK_ENV'] ||= "development"

require 'rubygems'
require 'bundler'
require 'mongoid'
require 'carrierwave'
require 'carrierwave/mongoid'
require 'fog'
require 'api/oauth'
require 'api/v1/index'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db(ENV['DBNAME'])
end

CarrierWave.configure do |config|
  config.permissions = 0777
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
    :aws_secret_access_key  => ENV['AWS_SECRET_KEY']
  }
  config.fog_directory  = ENV['AWS_BUCKET']
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

Bundler.setup
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

run Rack::Cascade.new([
  Birdbrains::API,
  Birdbrains::OAuth
])