class Album < ActiveRecord::Base
  has_many :photos
  validates :name, :presence => true, :length => { :minimum => 1 }
  validates :photos, length: { minimum: 0, maximum: 60 }
end
