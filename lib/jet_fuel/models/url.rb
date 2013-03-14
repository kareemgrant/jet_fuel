module JetFuel
  class Url < ActiveRecord::Base

    validates_presence_of :original
    validates_format_of :original, with: /^(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix, message: "Invalid format"
    before_create :generate_key

    private

    def generate_key
      self.key = "jt.fl/#{Array.new(5){rand(36).to_s(36)}.join}"
    end

  end
end