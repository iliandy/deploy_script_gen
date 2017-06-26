class CreateSecretKeys < ActiveRecord::Migration
  def change
    create_table :secret_keys do |t|
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
