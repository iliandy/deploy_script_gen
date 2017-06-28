class AddAppDirectoryToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :app_directory, :string
  end
end
