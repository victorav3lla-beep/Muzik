class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @bookmarkable = find_bookmarkable
    @bookmark = current_user.bookmarks.build(bookmarkable: @bookmarkable)

    if @bookmark.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: bookmark_success_message) }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: @bookmark.errors.full_messages.join(", ")) }
        format.turbo_stream
      end
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmarkable = @bookmark.bookmarkable
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: "Bookmark removed successfully.") }
      format.turbo_stream
    end
  end

  private

  def find_bookmarkable
    if params[:bookmarkable_type] && params[:bookmarkable_id]
      params[:bookmarkable_type].constantize.find(params[:bookmarkable_id])
    else
      raise ActionController::ParameterMissing, "Missing bookmarkable_type or bookmarkable_id"
    end
  end

  def bookmark_success_message
    case @bookmarkable
    when Playlist
      "Playlist liked successfully!"
    when User
      "You are now following #{@bookmarkable.email}!"
    else
      "Bookmarked successfully!"
    end
  end
end
