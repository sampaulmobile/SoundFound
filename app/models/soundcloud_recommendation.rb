class SoundcloudRecommendation < ActiveRecord::Base

  belongs_to :soundcloud_track, primary_key: "track_id", foreign_key: "track_id", class_name: "SoundcloudTrack"
  belongs_to :soundcloud_user, primary_key: "user_id", foreign_key: "user_id", class_name: "SoundcloudUser"

  has_many :triggers, dependent: :destroy
  has_many :alerts, through: :triggers

  validates :track_id, presence: true
  validates :user_id, presence: true

end
