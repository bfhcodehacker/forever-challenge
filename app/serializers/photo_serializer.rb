class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :url, :taken_at, :album
end
