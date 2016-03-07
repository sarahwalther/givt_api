class User < ApplicationRecord
  before_create :set_initial_api_key

  has_secure_password # http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html

  validates_presence_of :first_name, :last_name, :email
  validates_presence_of :password, if: :password
  validates_presence_of :type, on: :create
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates_length_of :password, in: 6..20, on: :create

  def admin?
    type == "Admin"
  end

  def customer?
    type == "Customer"
  end

  def manager?
    type == "Manager"
  end

  def employee?
    type == "Employee"
  end

  private

  def set_initial_api_key
    self.api_key ||= generate_api_key
  end

  def generate_api_key
    SecureRandom.uuid
  end
end
