class User < ActiveRecord::Base
  belongs_to :dojo
  has_secure_password
end
