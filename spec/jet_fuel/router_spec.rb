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

end