class AddActionsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :actionable, :boolean, default: false
  end
end
