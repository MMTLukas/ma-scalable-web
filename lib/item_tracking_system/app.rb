require 'sinatra/base'
require 'json'

require_relative '../authentification'

##
# This class represents an item store
# 
# @description	It provides 3 possible request methods: GET, POST and DELETE
# 							A user has to authentificate before using this methods
##

class ItemTrackingSystem < Sinatra::Base

	# objects which stores the items
	items = []
	length = items.length

	# before accessing the class methods the user has to authentificate
	# this handles the authentification module by forwarding the auth headers
	# to the user management system
  before do
    code = Authentification.request(env).code
    if code != 200
      status code
      halt
    end
  end

	# print all items
	get '/items' do
   if request.body.read.length == 0
     JSON.dump items
   else
     status 400
   end
 end

  # create a new item - if name and location attribute exists
  # add a programmatically id to the item
  post '/items' do
  	body = request.body.read

  	if body.length > 0
  		body = JSON.parse body

      if body["name"].nil? || body["location"].nil?
       status 400
       body JSON.dump({"error": "item need name and location as attribute"})
     else
      item = {
        "name": body["name"],
        "location": body["location"],
        "id": length
      }
      items.push item
      length = items.length

      status 201
      body JSON.dump item
    end
  else
    status 400
    body JSON.dump({"error": "item with name and location as attribute needed"})
  end
end

  # deletes an item from the store
  delete '/items/:id' do
  	if params[:id] && request.body.read.length == 0
  		items.delete_if { |item| item[:id] == params[:id].to_i }

  		if length > items.length
  			length = items.length
  			status 200
  		else
  			status 404
  		end
  	else
  		status 400
  	end
  end
end