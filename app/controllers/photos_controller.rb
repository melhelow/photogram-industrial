class PhotosController < ApplicationController
    before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
def create
  @photo = Photo.new(photo_params)
  @photo.owner = current_user  # <-- assign owner here

  if @photo.save
    redirect_to @photo, notice: "Photo was successfully created."
  else
    render :new
  end
end


  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.destroy!

    respond_to do |format|
      format.html { redirect_to photos_path, status: :see_other, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def liked
    @user = User.find_by!(username: params.fetch(:username))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
     def set_photo
    # pulls the :id out of params (as a String) and finds the Photo
    @photo = Photo.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
     def photo_params
    # require the top‐level :photo key, and then permit the individual attributes
    params
      .require(:photo)
      .permit(:image, :comments_count, :likes_count, :caption, :owner_id)
  end
end
