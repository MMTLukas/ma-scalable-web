require 'httparty'

##
# This class represents an client for the report system for accessing the LocationManagementSystem
##

class LocationManagementClient
  include HTTParty
  base_uri 'http://localhost:9393'
end
