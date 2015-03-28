require 'httparty'

##
# This class represents an client for the ReportSystem for accessing the ItemTrackingSystem
##

class ItemTrackingClient
  include HTTParty
  base_uri 'http://localhost:9292'
end
