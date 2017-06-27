class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :stack
      t.string :project_directory
      t.string :github_repo
      t.string :server_ip

      t.timestamps null: false
    end
  end
end
