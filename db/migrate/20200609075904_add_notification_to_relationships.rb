class AddNotificationToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :micropost_id, :integer
    add_column :relationships, :comment_id, :integer
    add_column :relationships, :action, :string
    add_column :relationships, :checked, :boolean, default: false, null: false
  end
end
