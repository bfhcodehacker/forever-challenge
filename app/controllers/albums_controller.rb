class AlbumsController < ApplicationController
  require 'will_paginate/array'
  before_action :authenticate_user!, :only => [:create, :update, :destroy]
  def index
    @albums = Album.all.as_json
    @albums = @albums.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    album = Album.find(params[:id])
    if album.blank?
      render :text => "Not Found", :status => :not_found
    end
    @photos = album.photos.as_json
    @album = AlbumSerializer.new(album).attributes 
  end

  def create
    @album = Album.create(album_params)
    if @album.valid? 
      redirect_to album_path
    else
      render :new, status => :unprocessable_entity
    end
  end

  def update
    @album = Album.find(params[:id])
    if @album.user != current_user
      return render :text => 'Not Allowed', :status => :forbidden
    end
    @album.update_attributes(album_params)
    if @album.valid?
      redirect_to root_path
    else
      render :edit, :status => :unprocessable_entity
    end
  end

  def destroy
    @album = Album.find(params[:id])
    if @album.user != current_user
      return render :text => 'Not Allowed', :status => :forbidden
    end
    @album.destroy
    redirect_to root_path
  end

  def add_many_photos
    params[:photos].map{|photo| Photo.create(photo)}
  end

  private

  def album_params
    params.require(:album).permit(:name, :position, :average_date, :page, :photos => [])
  end
end
