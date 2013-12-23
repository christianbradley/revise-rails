require "securerandom"

class ApiKey < ActiveRecord::Base
  after_initialize :generate_token
  validates :access_token, presence: true

  private

  def generate_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end

