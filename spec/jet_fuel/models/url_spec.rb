require 'spec_helper'
require 'rspec'
require 'rack/test'

describe JetFuel::Url do

  include Rack::Test::Methods

  def app
    JetFuel::Url
  end

  describe "Instance methods" do

    describe "#generate_key" do

      it "new key should be generated for a valid url" do
        pending
      end
    end

    describe "#validate_url" do

      context "when url is valid" do
        it "should allow valid url to be saved" do
          pending
        end
      end

      context "when url is not valid" do
        it "invalid url should not be saved" do
          pending
        end
      end
    end
  end


end
