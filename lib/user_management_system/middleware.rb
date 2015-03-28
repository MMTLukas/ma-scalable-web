require 'base64'

class Middleware

	def initialize(app)
		@app = app
	end

	def call(env)	
		if env['HTTP_AUTHORIZATION']
				username, password = Base64.decode64(env['HTTP_AUTHORIZATION'].gsub(/^Basic /, '')).split(":")

			if isAuthorized(username, password)
				@app.call(env)
			else
				[403, {'Content-Type' => 'text/plain'}, ['']]
			end
		else
			[401, {'Content-Type' => 'text/plain'}, ['']]
		end
	end

	def isAuthorized(username, password)
		username == "wanda" && password == "partyhard2000" ||
		username == "paul" && password == "thepanther" ||
		username == "anne" && password == "flytothemoon"
	end

end
