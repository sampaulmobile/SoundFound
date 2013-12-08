class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :soundcloud_user_id

      t.string :title

      t.integer :play_count_min, default: -1
      t.integer :play_count_max, default: -1

      t.integer :like_count_min, default: -1
      t.integer :like_count_max, default: -1

      t.integer :download_count_min, default: -1
      t.integer :download_count_max, default: -1

      t.integer :duration_min, default: -1
      t.integer :duration_max, default: -1

      t.boolean :downloadable, default: false
      t.boolean :unplayed, default: false
      t.boolean :played, default: false

      t.timestamps
    end
  end
end
