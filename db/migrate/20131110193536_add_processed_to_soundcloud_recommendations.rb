class AddProcessedToSoundcloudRecommendations < ActiveRecord::Migration
  def change
    add_column :soundcloud_recommendations, :processed, :boolean, default: false
  end
end
