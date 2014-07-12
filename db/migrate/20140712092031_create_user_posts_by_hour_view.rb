class CreateUserPostsByHourView < ActiveRecord::Migration
  def up
    execute <<SQL
CREATE MATERIALIZED VIEW user_posts_by_hour AS
  SELECT user_id,
         date_trunc('hour', remote_created_at) AS hour,
         count(*) AS posts_count
  FROM posts
  GROUP BY user_id, hour
WITH NO DATA
SQL
    add_index :user_posts_by_hour, :user_id
  end

  def down
    execute "DROP MATERIALIZED VIEW user_posts_by_hour"
  end
end
