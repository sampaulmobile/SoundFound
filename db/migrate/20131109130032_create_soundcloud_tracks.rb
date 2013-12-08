class CreateSoundcloudTracks < ActiveRecord::Migration
  def change
    create_table :soundcloud_tracks do |t|
      t.integer :track_id
      t.string :title
      t.integer :user_id

      t.datetime :stats_last_updated

      t.datetime :last_played
      t.integer :own_play_count, default: 0

      t.datetime :uploaded_at
      t.integer :duration, default: -1
      t.integer :play_count, default: -1
      t.integer :download_count, default: -1
      t.integer :favorite_count, default: -1
      t.integer :comment_count, default: -1
      t.boolean :downloadable, default: false

      t.timestamps
    end

    add_index :soundcloud_tracks, :user_id
    add_index :soundcloud_tracks, :track_id
    
  end
end
