class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @playlists = @user.playlists
  end
end
