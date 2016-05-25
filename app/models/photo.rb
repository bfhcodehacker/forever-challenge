class Photo < ActiveRecord::Base
  belongs_to :album
  validates_associated :album, :message => 'An album can only have 60 photos'
  validates :name, :presence => true, :length => { :minimum => 1 }
# commenting out regex that searches for url at end of url as current
# db/seeds.rb is pull images from web and needs query strings for size 
# at end
#  validates_format_of :url, :with => %r{\.(jpg|jpeg)\z}i  
  validates_format_of :url, :with => %r{\.(jpg|jpeg)}i
  after_create do
    update_album_date
  end
  after_destroy do
    update_album_date
  end

  def update_album_date
    if album.photos.size == 0 
      average_date = nil
    else
      total_time = 0.0
      album.photos.each do |photo|
        total_time += Time.parse(photo.taken_at.to_s).to_f
      end
      avg = Time.at(total_time / album.photos.size)
      average_date = Date.parse(avg.to_s)
    end
    album.update_attribute(:average_date, average_date) 
  end
end
