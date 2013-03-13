module JetFuel
  class Url < ActiveRecord::Base

    # add before_validation callback to determine if urls were prepended with http/https
    ## this could effectively replace valid_url? check
    before_validation :check_uri_scheme
    validates_presence_of :original
    validate :valid_uri?
    validates_format_of :original, with: /^(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix, message: "Invalid format"
    before_create :generate_key




    def valid_uri?
      u = URI::parse(original)
      if u.scheme.nil? #!(original.kind_of?(URI::HTTP) || original.kind_of?(URI::HTTPS))
        errors.add(:original, "Invalid uri")
      else
        true
      end
    end

    private

    def generate_key
      self.key = "jt.fl/#{Array.new(5){rand(36).to_s(36)}.join}"
    end

    def check_uri_scheme
      self.original = "http://#{original}"
    end

  end
end