require 'httparty'

##
# This module helps the systems to authentificate against the UserManagementSystem
##

module Authentification

	# Forwards the http basic auths headers to the UserManagementSystem
	def self.request(env)
		HTTParty.get("http://localhost:9595/user", headers: self.getHeaders(env))
	end

	# Helps to get the authentification header
	def self.getHeaders(env)
		headers = {}

		if env["HTTP_AUTHORIZATION"]
			headers["AUTHORIZATION"] = env["HTTP_AUTHORIZATION"]
		end

		headers
	end

end