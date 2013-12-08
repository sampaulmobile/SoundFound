class Trigger < ActiveRecord::Base
  belongs_to :soundcloud_user
  belongs_to :soundcloud_track
  belongs_to :alert

end
