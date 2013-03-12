module JetFuel
  class Url < ActiveRecord::Base

    validates :original, presence: true
    #before_create :validate_url
    before_create :generate_key


    private

    def generate_key
      self.key = "jt.fl/#{Array.new(5){rand(36).to_s(36)}.join}"
    end

  end
end