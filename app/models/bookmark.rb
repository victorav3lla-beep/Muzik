class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  # Ensure a user cannot bookmark the same item twice
  validates :user_id, uniqueness: { scope: [:bookmarkable_type, :bookmarkable_id],
                                    message: "has already bookmarked this item" }
end
