module JetFuel
  class Url < ActiveRecord::Base

    validates :original, :key, presence: true

    # def key
    #    "http://re.emo/#{Array.new(5){rand(36).to_s(36)}.join}"
    # end

  end
end