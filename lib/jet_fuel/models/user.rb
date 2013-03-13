module JetFuel
  class User < ActiveRecord::Base
    has_many :vanity_urls

    validates :username, uniqueness: true
    validates :api_key, uniqueness: true
    before_create :generate_api_key

    private

    def generate_api_key
      self.api_key = "#{Array.new(32){rand(36).to_s(36)}.join}"
    end

  end
end