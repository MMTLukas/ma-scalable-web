require 'sinatra/base'
require 'json'

##
# This class represents an item store
# 
# @description	It provides 3 possible request methods: GET, POST and DELETE
# 							A user has to authentificate before using this methods
##

class LocationManagementSystem < Sinatra::Base

	# objects which stores the locations
	locations = [
	  {
	    "name": "Office Alexanderstraße",
	    "address": "Alexanderstraße 45, 33853 Bielefeld, Germany",
	    "id": 0
	  },
	  {
	    "name": "Warehouse Hamburg",
	    "address": "Gewerbestraße 1, 21035 Hamburg, Germany",
	    "id": 1
	  },
	  {
	    "name": "Headquarters Salzburg",
	    "address": "Mozart Gasserl 4, 13371 Salzburg, Austria",
	    "id": 2
	  }
	]
	length = locations.length

	# before accessing the class methods the user has to authentificate
	# this handles the authentification module by forwarding the auth headers
	# to the user management system
	before do
  	if Authentification.request(env).code != 200
  		status 403
  		halt
  	end
	end

	# print all locations
	get '/locations' do
  	if request.body.read.length == 0
			JSON.pretty_generate locations
		else
			status 400
		end
  end

  # create a new location - if name and address attribute exists
  # add a programmatically id to the item
  post '/locations' do
  	body = request.body.read

  	if body.length > 0
  		body = JSON.parse body

	  	if body["name"].nil? || body["address"].nil?
	  		status 400
	  		body JSON.dump({"error": "location need name and address as attribute"})
  		else
  			location = {
  				"name": body["name"],
  				"address": body["address"],
  				"id": length
  			}
		  	locations.push location
		  	length = locations.length

		  	status 201
		  	body JSON.pretty_generate location
		  end
		else
				status 400
	  		body JSON.dump({"error": "location with name and address as attribute needed"})
		end
  end

  # deletes an location from the store
  delete '/locations/:id' do
  	if params[:id] && request.body.read.length == 0
  		locations.delete_if { |location| location[:id] == params[:id].to_i }

  		if length > locations.length
  			length = locations.length
  			status 200
  		else
  			status 404
  		end
  	else
  		status 400
  	end
  end
end