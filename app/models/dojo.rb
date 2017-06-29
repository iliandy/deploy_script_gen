class Dojo < ActiveRecord::Base
	has_many :users, dependent: :delete_all
	has_many :admins, dependent: :delete_all

	validates :name, presence:true
end
