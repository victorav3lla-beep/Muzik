class ChangeContentTypeFromMessages < ActiveRecord::Migration[7.1]
  def change
    change_column :messages, :content, :text
  end
end
