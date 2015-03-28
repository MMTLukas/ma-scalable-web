require 'sinatra/base'
require 'json'

require_relative './item_tracking_client'
require_relative './location_management_client'
require_relative '../authentification'

class ReportSystem < Sinatra::Base

	before do
  	if Authentification.request(env).code != 200
  		status 403
  		halt
  	end
	end

  get '/reports/by-location' do

		reports = JSON.parse LocationManagementClient.get("/locations", headers: Authentification.getHeaders(env)).body
		items = JSON.parse ItemTrackingClient.get("/items", headers: Authentification.getHeaders(env)).body

		reports.each do |location|
			location["items"] = []
			items.each do |item| 
				if item["location"] == location["id"]
					location["items"].push item
				end
			end
		end

  	JSON.pretty_generate reports
  end
  
end