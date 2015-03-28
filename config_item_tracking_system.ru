require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path('../lib/item_tracking_system/app', __FILE__)
require File.expand_path('../lib/authentification', __FILE__)

run ItemTrackingSystem.new
