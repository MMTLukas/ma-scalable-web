require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path('../lib/report_system/app', __FILE__)
require File.expand_path('../lib/report_system/item_tracking_client', __FILE__)
require File.expand_path('../lib/report_system/location_management_client', __FILE__)
require File.expand_path('../lib/authentification', __FILE__)

run ReportSystem.new