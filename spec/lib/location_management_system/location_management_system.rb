require 'rack/test'
require 'json'

require_relative '../../../lib/location_management_system/app'

##
# ATTENTION: UserManagementSystem has to be started
# Start it with bundle exec rackup -o 0.0.0.0 -p 9595 config_user_management_system.ru
##

describe LocationManagementSystem do
  include Rack::Test::Methods

  def app
    LocationManagementSystem.new
  end

  context '/locations' do
    describe "unauthorized access" do
      before do
        get '/locations'
      end

      it 'should be denied' do
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized access with wrong credentials" do
      before do
        basic_authorize("smith", "secret")
        get '/locations'
      end

      it 'should be denied' do
        expect(last_response.status).to be(403)
      end
    end

    describe "authorized access" do
      before do
        basic_authorize("paul", "thepanther")
        get '/locations'
      end

      it 'should be allowed' do
        expect(last_response.status).to be(200)
      end

      it 'should response with empty array' do
        expect(last_response.body).to eq("[]")
      end
    end

    describe "unauthorized write" do
      before do
        post '/locations'
      end

      it 'should be denied' do
        expect(last_response.status).to be(401)
      end
    end

    describe "unauthorized write" do
      before do
        post '/locations'
      end

      it 'should be denied' do
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized write with wrong credentials" do
      before do
        basic_authorize("smith", "secret")
        post '/locations'
      end

      it 'should be denied' do
        expect(last_response.status).to be(403)
      end
    end

    describe "authorized write with incorrect input" do
      location =  {
        "wrong1": "FHS",
        "wrong2": "Urstein Sued 1"
      }

      before do
        basic_authorize("paul", "thepanther")
        post '/locations', JSON.dump(location)
      end

      it 'should be denied' do
        expect(last_response.status).to be(400)
      end
    end

    describe "authorized write with correct input" do
      location =  {
        "name": "FHS",
        "address": "Urstein Sued 1"
      }

      before do
        basic_authorize("paul", "thepanther")
        post '/locations', JSON.dump(location)
      end

      after do
        delete '/locations/0'
      end

      it 'should response with location inserted' do
        expect(last_response.status).to be(201)

        location["id"] = 0
        body = JSON.parse last_response.body
        expect(body[:id]).to eq(location[:id])
        expect(body["name"]).to eq(location[:name])
        expect(body["address"]).to eq(location[:address])
      end
    end

    describe "unauthorized delete" do
      it 'should be denied' do
        delete "/locations/99"
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized delete with wrong id but correct credentials" do
      it 'should be allowed but show there is no resource' do
        basic_authorize("paul", "thepanther")
        delete "/locations/99"
        expect(last_response.status).to be(404)
      end
    end

    describe "authorized delete with correct id and credentials" do
      location =  {
        "name": "FHS",
        "address": "Urstein Sued 1"
      }

      before do
        basic_authorize("paul", "thepanther")
        post "/locations", JSON.dump(location)
        id = JSON.parse(last_response.body)["id"]
        delete "/locations/" + id.to_s
      end

      it 'should be allowed' do
        expect(last_response.status).to be(200)
      end

      it 'should have deleted the location' do
        basic_authorize("paul", "thepanther")
        get "/locations"
        expect(last_response.body).to eq("[]")
      end
    end
  end
end