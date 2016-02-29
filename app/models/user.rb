class User < ApplicationRecord
  before_create :set_initial_api_key
  # has_secure_password
  # EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true #, :format => EMAIL_REGEX
  # attr_accessor :password
  # validates :password, :confirmation => true #password_confirmation attr
  # validates_length_of :password, :in => 6..20, :on => :create

  private

  def set_initial_api_key
    self.api_key ||= generate_api_key
  end

  def generate_api_key
    SecureRandom.uuid
  end
end
