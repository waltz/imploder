namespace :ensure_derivatives do
  desc "Ensure that all derivatives have been built for videos"
  task :go => :environment do
    Video.find_each do |video|
      video.clip_derivatives!
      video.save
    end
  end
end
