require 'spec_helper'
require 'rack/test'

describe JetFuel::Router do

  include Rack::Test::Methods

  def app
    JetFuel::Router
  end

  describe 'GET /' do
    it "returns homepage with welcome message" do
      get '/'

      last_response.status.should eq(200)
    end
  end

  describe 'POST /' do
    it "saves the url to the database" do
      post '/', original: "http://jumpstartlab.com", key: "reemo"

      last_response.status.should eq(200)
    end
  end

end