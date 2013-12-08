class CreateSoundcloudRecommendations < ActiveRecord::Migration
  def change
    create_table :soundcloud_recommendations do |t|

      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end

    add_index :soundcloud_recommendations, :user_id
    add_index :soundcloud_recommendations, [:user_id, :track_id], unique: true
    
  end
end
