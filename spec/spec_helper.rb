require 'rubygems'
require 'rack/test'
require 'grape'
require 'bundler'
require 'mongoid'

Bundler.setup :default, :test
ENV['RACK_ENV'] = 'test'


Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db(ENV['DBNAME'])
end

require_relative '../api/v1/index.rb'