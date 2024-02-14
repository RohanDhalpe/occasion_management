class User < ApplicationRecord
  belongs_to :role
  has_many :bookings

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, on: :create


  def admin?
    role.name == ROLES[:admin]
  end

  def customer?
    role.name == ROLES[:customer]
  end

  def as_json(options = {})
    super(options.merge(except: [:created_at, :updated_at, :password_digest]))
  end
end
