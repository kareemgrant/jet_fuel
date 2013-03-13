module JetFuel
  class VanityUrl < ActiveRecord::Base

    validates :base, uniqueness: true

  end
end