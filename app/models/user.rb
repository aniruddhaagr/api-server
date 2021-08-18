class User < ApplicationRecord
   attr_accessor :password

   has_many :tokens

   validates :first_name, :last_name, :email, presence: true
   validates :password, presence: true, on: :create
   validates_length_of :password, :minimum => 5, allow_blank: true
   validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
   before_validation :encrypt_password, on: :create

   def encrypt_password
      self.encrypted_password = BCrypt::Password.create(password)
   end

   def valid_password?(new_password)
      BCrypt::Password.new(self.encrypted_password) == new_password
   end
end
