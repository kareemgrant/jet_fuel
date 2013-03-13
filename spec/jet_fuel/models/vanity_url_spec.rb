require 'spec_helper'
require 'rspec'
require 'rack/test'

describe JetFuel::VanityUrl do

  include Rack::Test::Methods

  def app
    JetFuel::VanityUrl
  end

end