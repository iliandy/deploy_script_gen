class SecretKey < ActiveRecord::Base
  has_secure_password
end
