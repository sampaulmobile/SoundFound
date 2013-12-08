class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|

      t.integer :soundcloud_user_id
      t.integer :alert_id
      t.integer :track_id

      t.boolean :processed, default: false

      t.timestamps
    end
    
    add_index :triggers, :soundcloud_user_id
    add_index :triggers, [:alert_id, :track_id], unique: true
  end
end
