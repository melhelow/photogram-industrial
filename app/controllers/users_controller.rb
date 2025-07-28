class UsersController < ApplicationController
  before_action :find_user, only: [:show, :liked, :feed, :discover]

    def index
    if params[:q] && params[:q][:username_cont].present?
      search_term = params[:q][:username_cont].downcase
      @users = User.where("LOWER(username) LIKE ?", "%#{search_term}%")
    else
      @users = User.none
    end
  end
  def show
  end

  def liked
    @liked_photos = @user.liked_photos.includes(:owner)
  end

  def feed
    # You can use something like this if your model has it:
    @feed_photos = @user.feed
  end

  def discover
    # You can use something like this if your model has it:
    @photos = current_user.discover.order(created_at: :desc)

  end

  private

  def find_user
    @user = User.find_by(username: params[:username])
    redirect_to root_path, alert: "User not found" unless @user
  end
end
