class Script < ActiveRecord::Base
  require "resolv"
  # github_regex = /^(https):\/\/(github)([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
  validates :stack, :project_directory, presence: true
  validates :github_repo, presence: true
  validates :server_ip, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }
end
