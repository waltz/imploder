class CreateVideoThumbnails < ActiveRecord::Migration[5.2]
  def change
    Video.find_each do |video|
      video.clip_derivatives!
      video.save
    end
  end
end
