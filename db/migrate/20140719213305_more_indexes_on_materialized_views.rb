class MoreIndexesOnMaterializedViews < ActiveRecord::Migration
  def up
    add_index :posts_by_dow, :day
    add_index :posts_by_dow, :dow
    add_index :posts_by_hod, :day
    add_index :posts_by_hod, :hod
    add_index :posts_by_hour, :hour
    add_index :user_posts_by_dow, :user_id
    add_index :user_posts_by_dow, :day
    add_index :user_posts_by_dow, :dow
    add_index :user_posts_by_hod, :user_id
    add_index :user_posts_by_hod, :day
    add_index :user_posts_by_hod, :hod
    add_index :user_posts_by_hour, :user_id
    add_index :user_posts_by_hour, :hour
  end

  def down
    remove_index :posts_by_dow, :day
    remove_index :posts_by_dow, :dow
    remove_index :posts_by_hod, :day
    remove_index :posts_by_hod, :hod
    remove_index :posts_by_hour, :hour
    remove_index :user_posts_by_dow, :user_id
    remove_index :user_posts_by_dow, :day
    remove_index :user_posts_by_dow, :dow
    remove_index :user_posts_by_hod, :user_id
    remove_index :user_posts_by_hod, :day
    remove_index :user_posts_by_hod, :hod
    remove_index :user_posts_by_hour, :user_id
    remove_index :user_posts_by_hour, :hour
  end
end
