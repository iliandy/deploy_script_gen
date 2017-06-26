class Dojo < ActiveRecord::Base
	has_many :users
	
	validate :name, presence:true
end
