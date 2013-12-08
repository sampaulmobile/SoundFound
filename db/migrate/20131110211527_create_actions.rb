class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :alert_id
      t.string :action_type

      t.timestamps
    end
  end
end
