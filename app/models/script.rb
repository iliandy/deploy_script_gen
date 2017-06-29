class Script < ActiveRecord::Base
  require "resolv"
  
  validates :stack, :project_directory, presence: true
  validates :github_repo, presence: true
  validates :server_ip, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }
end
