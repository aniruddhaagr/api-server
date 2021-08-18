class Token < ApplicationRecord
  belongs_to :user
  before_validation :generate_auth_token

  private
  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex(10)
      break unless Token.where(auth_token: auth_token).exists?
    end
  end
end
