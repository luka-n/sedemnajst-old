class CreateUserPostsByDow < ActiveRecord::Migration
  def up
    execute <<SQL
CREATE MATERIALIZED VIEW user_posts_by_dow AS
  SELECT user_id,
         date_trunc('day', remote_created_at) AS day,
         date_part('dow', remote_created_at) AS dow,
         count(*) AS posts_count
  FROM posts
  GROUP BY user_id, day, dow
WITH NO DATA
SQL
    add_index :user_posts_by_dow, :user_id
  end

  def down
    execute "DROP MATERIALIZED VIEW user_posts_by_dow"
  end
end
