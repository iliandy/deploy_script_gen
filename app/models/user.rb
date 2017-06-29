class User < ActiveRecord::Base
  belongs_to :dojo
	has_one :admin, dependent: :delete

  has_secure_password
	email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, presence: true, length: {minimum: 2}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format:{with: email_regex}
end
