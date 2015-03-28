require 'httparty'

module Authentification

	def self.request(env)
		HTTParty.get("http://localhost:9595/user", headers: self.getHeaders(env))
	end

	def self.getHeaders(env)
		headers = {}

		if env["HTTP_AUTHORIZATION"]
			headers["AUTHORIZATION"] = env["HTTP_AUTHORIZATION"]
		end

		headers
	end

end