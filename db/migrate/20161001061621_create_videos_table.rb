class CreateVideosTable < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.timestamps
      t.string :status
      t.string :gif_url
      t.string :youtube_url
      t.integer :audio_start_delay
    end
  end
end
