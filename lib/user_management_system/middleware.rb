require 'base64'

##
# This class represents a middleware for the UserManagementSystem to authentificate users
##

class Middleware

	# Before authentifacte the UserManagementSystem gets stored  
	# to get executed after authentification
	def initialize(app)
		@app = app
	end

	# After initialization the authorization header gets parsed and
	# the username and the password gets be checked
	def call(env)	
		if env['HTTP_AUTHORIZATION']
				username, password = Base64.decode64(env['HTTP_AUTHORIZATION'].gsub(/^Basic /, '')).split(":")

			if isAuthenticated(username, password)
				@app.call(env)
			else
				[403, {'Content-Type' => 'text/plain'}, ['']]
			end
		else
			[401, {'Content-Type' => 'text/plain'}, ['']]
		end
	end

	# Helps to authenticate users credentials
	def isAuthenticated(username, password)
		username == "wanda" && password == "partyhard2000" ||
		username == "paul" && password == "thepanther" ||
		username == "anne" && password == "flytothemoon"
	end

end
