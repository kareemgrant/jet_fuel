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

  describe 'POST /urls' do

    context "when url does not already exist" do

      it "saves the url to the database" do
        pending
        post '/urls', original: "jumpstartlab.com"

        last_response.status.should eq(200)
      end
    end

    context "when url already exists" do

      before do
        # fake_url = stub("URL",key: "AGAGAG")
        # result_set = stub("result_set",first_or_create: fake_url)
        # Url.stub(:where).with(original: params[:original]).and_return(result_set)
      end

      it "saves the url to the database" do
        pending
        post '/urls', original: "jumpstartlab.com"

        expect(app.count).to eq(1)
      end
    end

  end

end