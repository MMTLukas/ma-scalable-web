require 'sinatra/base'
require 'json'

class App < Sinatra::Base
	items = [
	  {
	    "name": "Johannas PC",
	    "location": 1,
	    "id": 456
	  },
	  {
	    "name": "Johannas desk",
	    "location": 123,
	    "id": 457
	  },
	  {
	    "name": "Lobby chair #1",
	    "location": 2,
	    "id": 501
	  }
	]
	length = items.length

	before do
  	if Authentification.request(env).code != 200
  		status 403
  		halt
  	end
	end

	get '/items' do
  	if request.body.read.length == 0
			JSON.pretty_generate items
		else
			status 400
		end
  end

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
		  	body JSON.pretty_generate item
		  end
		else
				status 400
	  		body JSON.dump({"error": "item with name and location as attribute needed"})
		end
  end

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