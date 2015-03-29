require 'rack/test'

require_relative '../../../lib/report_system/app'
require_relative '../../../lib/authentification.rb'

##
# ATTENTION: UserManagementSystem, ItemTrackingSystem and LocationManagementSystem has to be started
# Start them with
# => bundle exec rackup -o 0.0.0.0 -p 9292 config_item_tracking_system.ru
# => bundle exec rackup -o 0.0.0.0 -p 9393 config_location_management_system.ru
# => bundle exec rackup -o 0.0.0.0 -p 9595 config_user_management_system.ru
##

describe ReportSystem do
  include Rack::Test::Methods

  def app
    ReportSystem.new
  end

  context '/reports/by-location' do
    describe "unauthorized" do
      before do
        get '/reports/by-location'
      end

      it 'should require a http basic auth' do
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized with wrong credentials" do
      before do
        basic_authorize("smith", "secret")
        get '/reports/by-location'
      end

      it 'should not authenticate user with wrong credentials' do
        expect(last_response.status).to be(403)
      end
    end

    describe "authorized" do
      before do
        self.basic_authorize("paul", "thepanther")
        get '/reports/by-location'
      end

      it 'should authenticate user with correct credentials' do
        expect(last_response.status).to be(200)
      end

      it 'should response with empty body' do
        expect(last_response.body).to eq("[]")
      end
    end

    describe "authorized filling and requesting reports" do
      item = {
        "name": "Smiths PC",
        "location": 0
      }
      location = {
        "name": "FHS",
        "address": "Urstein Sued 1"
      }

      before do
        # TODO
        basic_authorize("paul", "thepanther")

        HTTParty.post("http://localhost:9292/items", body: item);
        HTTParty.post("http://localhost:9393/locations", body: location);

        get '/reports/by-location'
      end

      it 'should response with the correct object' do
        object = location
        object[:items] = item
        expect(last_response.body).to eq(object)
      end
    end
  end
end