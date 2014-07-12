class CreateUserPostsByHod < ActiveRecord::Migration
  def up
    execute <<SQL
CREATE MATERIALIZED VIEW user_posts_by_hod AS
  SELECT user_id,
         date_trunc('hour', remote_created_at) AS hour,
         date_part('hour', remote_created_at) AS hod,
         count(*) AS posts_count
  FROM posts
  GROUP BY user_id, hour, hod
WITH NO DATA
SQL
    add_index :user_posts_by_hod, :user_id
  end

  def down
    execute "DROP MATERIALIZED VIEW user_posts_by_hod"
  end
end
