module JetFuel
  class VanityUrl < ActiveRecord::Base
    belongs_to :user

    validates :base, uniqueness: true

  end
end