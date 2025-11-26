module ApplicationHelper
  def bookmark_button(bookmarkable, user = current_user)
    return unless user

    existing_bookmark = user.bookmarks.find_by(bookmarkable: bookmarkable)
    count = bookmarkable.bookmarks.count
    bookmarkable_id = "bookmark_#{bookmarkable.class.name.downcase}_#{bookmarkable.id}"

    content_tag :div, id: bookmarkable_id, data: {
      controller: "bookmark",
      bookmark_bookmarked_value: existing_bookmark.present?,
      bookmark_count_value: count
    } do
      if existing_bookmark
        # Show "Unlike" button with count
        button_to unbookmark_path(existing_bookmark, bookmarkable),
                  method: :delete,
                  class: "#{bookmark_button_class(bookmarkable, true)} bookmark-btn",
                  data: {
                    turbo_method: :delete,
                    action: "click->bookmark#toggle"
                  } do
          content_tag(:span, bookmark_icon(bookmarkable), class: "bookmark-icon", data: { bookmark_target: "icon" }) +
          content_tag(:span, " #{count}", data: { bookmark_target: "count" }) +
          content_tag(:span, " #{count == 1 ? bookmark_singular(bookmarkable) : bookmark_plural(bookmarkable)}")
        end
      else
        # Show "Like" button with count
        button_to bookmarks_path(bookmarkable_type: bookmarkable.class.name, bookmarkable_id: bookmarkable.id),
                  method: :post,
                  class: "#{bookmark_button_class(bookmarkable, false)} bookmark-btn",
                  data: {
                    turbo_method: :post,
                    action: "click->bookmark#toggle"
                  } do
          content_tag(:span, bookmark_icon(bookmarkable), class: "bookmark-icon", data: { bookmark_target: "icon" }) +
          content_tag(:span, " #{count}", data: { bookmark_target: "count" }) +
          content_tag(:span, " #{count == 1 ? bookmark_singular(bookmarkable) : bookmark_plural(bookmarkable)}")
        end
      end
    end
  end

  def likes_count(bookmarkable)
    count = bookmarkable.bookmarks.count
    case bookmarkable
    when Playlist
      "#{count} #{count == 1 ? 'like' : 'likes'}"
    when User
      "#{count} #{count == 1 ? 'follower' : 'followers'}"
    else
      "#{count} #{count == 1 ? 'bookmark' : 'bookmarks'}"
    end
  end

  private

  def unbookmark_path(bookmark, bookmarkable)
    bookmark_path(bookmark, bookmarkable_type: bookmarkable.class.name, bookmarkable_id: bookmarkable.id)
  end

  def bookmark_button_class(bookmarkable, bookmarked)
    base_class = "btn "
    case bookmarkable
    when Playlist
      bookmarked ? "#{base_class}btn-danger" : "#{base_class}btn-outline-danger"
    when User
      bookmarked ? "#{base_class}btn-primary" : "#{base_class}btn-outline-primary"
    else
      bookmarked ? "#{base_class}btn-secondary" : "#{base_class}btn-outline-secondary"
    end
  end

  def bookmark_icon(bookmarkable)
    case bookmarkable
    when Playlist
      "❤️"
    when User
      "👤"
    else
      "⭐"
    end
  end

  def unbookmark_icon(bookmarkable)
    case bookmarkable
    when Playlist
      "💔"
    when User
      "👤"
    else
      "⭐"
    end
  end

  def bookmark_text(bookmarkable)
    case bookmarkable
    when Playlist
      "Like"
    when User
      "Follow"
    else
      "Bookmark"
    end
  end

  def unbookmark_text(bookmarkable)
    case bookmarkable
    when Playlist
      "Unlike"
    when User
      "Unfollow"
    else
      "Remove"
    end
  end

  def bookmark_singular(bookmarkable)
    case bookmarkable
    when Playlist
      "like"
    when User
      "follower"
    else
      "bookmark"
    end
  end

  def bookmark_plural(bookmarkable)
    case bookmarkable
    when Playlist
      "likes"
    when User
      "followers"
    else
      "bookmarks"
    end
  end
end
