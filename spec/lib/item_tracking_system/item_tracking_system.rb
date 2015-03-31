require 'rack/test'
require 'json'

require_relative '../../../lib/item_tracking_system/app'

##
# ATTENTION: UserManagementSystem has to be started
# Start it with bundle exec rackup -o 0.0.0.0 -p 9595 config_user_management_system.ru
##

describe ItemTrackingSystem do
  include Rack::Test::Methods

  def app
    ItemTrackingSystem.new
  end

  context '/items' do
    describe "unauthorized access" do
      before do
        get '/items'
      end

      it 'should be denied' do
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized access with wrong credentials" do
      before do
        basic_authorize("smith", "secret")
        get '/items'
      end

      it 'should be denied' do
        expect(last_response.status).to be(403)
      end
    end

    describe "authorized access" do
      before do
        basic_authorize("paul", "thepanther")
        get '/items'
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
        post '/items'
      end

      it 'should be denied' do
        expect(last_response.status).to be(401)
      end
    end

    describe "unauthorized write" do
      before do
        post '/items'
      end

      it 'should be denied' do
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized write with wrong credentials" do
      before do
        basic_authorize("smith", "secret")
        post '/items'
      end

      it 'should be denied' do
        expect(last_response.status).to be(403)
      end
    end

    describe "authorized write with incorrect input" do
      item =  {
        "wrong1": "Smiths PC",
        "wrong2": 1
      }

      before do
        basic_authorize("paul", "thepanther")
        post '/items', JSON.dump(item)
      end

      it 'should be denied' do
        expect(last_response.status).to be(400)
      end
    end

    describe "authorized write with correct input" do
      item =  {
        "name": "Smiths PC",
        "location": 1
      }

      before do
        basic_authorize("paul", "thepanther")
        post '/items', JSON.dump(item)
      end

      after do
        delete '/items/0'
      end

      it 'should response with item inserted' do
        expect(last_response.status).to be(201)

        item["id"] = 0
        body = JSON.parse last_response.body
        expect(body[:id]).to eq(item[:id])
        expect(body["name"]).to eq(item[:name])
        expect(body["location"]).to eq(item[:location])
      end
    end

    describe "unauthorized delete" do
      it 'should be denied' do
        delete "/items/99"
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized delete with wrong id but correct credentials" do
      it 'should be allowed but show there is no resource' do
        basic_authorize("paul", "thepanther")
        delete "/items/99"
        expect(last_response.status).to be(404)
      end
    end

    describe "authorized delete with wrong id but correct credentials" do
      item =  {
        "name": "Smiths PC",
        "location": 1
      }
      currentStorage = ""

      before do
        basic_authorize("paul", "thepanther")

        get "/items"
        currentStorage = last_response.body

        post "/items", JSON.dump(item)

        id = JSON.parse(last_response.body)["id"]
        delete "/items/" + id.to_s
      end

      it 'should be allowed' do
        expect(last_response.status).to be(200)
      end

      it 'should have deleted the item' do
        basic_authorize("paul", "thepanther")
        get "/items"
        expect(last_response.body).to eq(currentStorage)
      end
    end
  end
end