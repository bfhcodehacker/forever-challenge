class PhotosController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :update, :destroy]
  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
    if @photo.blank?
      render :text => "Not Found", :status => :not_found
    end
  end

  def create
    #@photo = current_user.photos.create(photo_params)
    @photo.create(photo_params)
    if @photo.valid? 
      redirect_to photo_path
    else
      render :new, status => :unprocessable_entity
    end
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.user != current_user
      return render :text => 'Not Allowed', :status => :forbidden
    end
    @photo.update_attributes(photo_params)
    if @photo.valid?
      redirect_to root_path
    else
      render :edit, :status => :unprocessable_entity
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to root_path
  end

  private

  def photo_params
    params.require(:photo).permit(:name, :description, :url, :taken_at, :album)
  end
end
