module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "SoundFound"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def convert_ms_to_time(ms)
    total_minutes = ms / 1000 / 1.minutes
    seconds_in_last_minute = ms / 1000 - total_minutes.minutes.seconds
    "#{total_minutes}m #{seconds_in_last_minute}s"
  end
  
end
