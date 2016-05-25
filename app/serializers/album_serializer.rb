class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :average_date, :num_photos

  def num_photos
    object.photos.count
  end
end
