require 'rack/test'

require_relative '../../../lib/user_management_system/app'
require_relative '../../../lib/user_management_system/middleware'

describe UserManagementSystem do
  include Rack::Test::Methods

  let(:app) {
    Rack::Builder.new {
      use Middleware
      run UserManagementSystem.new
    }
  }

  context '/user' do
    describe "unauthorized" do
      before do
        get '/user'
      end

      it 'should require a http basic auth' do
        expect(last_response.status).to be(401)
      end
    end

    describe "authorized with wrong credentials" do
      before do
        basic_authorize("smith", "secret")
        get '/user'
      end

      it 'should not authenticate user with wrong credentials' do
        expect(last_response.status).to be(403)
      end
    end

    describe "authorized" do
      before do
        basic_authorize("paul", "thepanther")
        get '/user'
      end

      it 'should authenticate user with correct credentials' do
        expect(last_response.status).to be(200)
      end

      it 'should response with empty body' do
        expect(last_response.body.empty?).to be true
      end
    end
  end
end