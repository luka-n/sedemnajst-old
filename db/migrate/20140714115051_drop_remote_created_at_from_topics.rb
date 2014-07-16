class DropRemoteCreatedAtFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :remote_created_at
  end
end
