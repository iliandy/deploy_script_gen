class Dojo < ActiveRecord::Base
	validate :name, presence:true
end
