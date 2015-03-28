require 'sinatra/base'

##
# This class represents the user management system for all the others systems
# 
# @description: It uses a middleware which allow to authentificate users
##

class UserManagementSystem < Sinatra::Base
  get '/user' do
  	# empty response
  end
end
