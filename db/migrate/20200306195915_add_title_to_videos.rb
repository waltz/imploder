class AddTitleToVideos < ActiveRecord::Migration[5.2]
  class Videos20200306 < ActiveRecord::Base
    self.table_name = 'videos'
  end

  def self.up
    add_column :videos, :title, :string
    Videos20200306.find_each do |video|
      video.update_column(:title, "Fun Implosion #{video.id}")
    end
  end

  def self.down
    remove_column :videos, :title
  end
end
