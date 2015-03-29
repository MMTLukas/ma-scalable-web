require 'sinatra/base'
require 'json'

require_relative './item_tracking_client'
require_relative './location_management_client'
require_relative '../authentification'

##
# This class combines the ItemTrackingSystem and the LocationManagementSystem
# 
# @description	It has only one route /reports/by-location
#  							This route responses with an reports object
#  							This object contains locations extended with its items
##

class ReportSystem < Sinatra::Base

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

  # prints all locations extended with its items
  get '/reports/by-location' do
  	reports = JSON.parse LocationManagementClient.get("/locations", headers: Authentification.getHeaders(env)).body
  	items = JSON.parse ItemTrackingClient.get("/items", headers: Authentification.getHeaders(env)).body
  	JSON.dump combine(reports, items)
  end

  # combines the reports and items
  def combine(reports, items)
  	reports.each do |location|
  		location["items"] = []
  		items.each do |item| 
  			if item["location"] == location["id"]
  				location["items"].push item
  			end
  		end
  	end
  	return reports
  end  
end