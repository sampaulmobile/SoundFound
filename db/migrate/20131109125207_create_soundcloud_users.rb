class CreateSoundcloudUsers < ActiveRecord::Migration
  def change
    create_table :soundcloud_users do |t|
      t.integer :user_id

      t.string :username
      t.string :name
      t.string :email

      t.datetime :tracks_updated_at

      t.string :access_token
      t.string :refresh_token
      t.string :expires_at
      
      t.timestamps
    end
  end
end
