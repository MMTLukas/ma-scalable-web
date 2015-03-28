require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path('../lib/user_management_system/app', __FILE__)
require File.expand_path('../lib/user_management_system/middleware', __FILE__)

use Middleware
run UserManagementSystem.new
