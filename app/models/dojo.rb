class Dojo < ActiveRecord::Base
	has_many :users

	validates :name, presence:true
end
