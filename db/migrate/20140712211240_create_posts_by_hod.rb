class CreatePostsByHod < ActiveRecord::Migration
  def up
    execute <<SQL
CREATE MATERIALIZED VIEW posts_by_hod AS
  SELECT date_trunc('hour', remote_created_at) AS hour,
         date_part('hour', remote_created_at) AS hod,
         count(*) AS posts_count
  FROM posts
  GROUP BY hour, hod
WITH NO DATA
SQL
  end

  def down
    execute "DROP MATERIALIZED VIEW posts_by_hod"
  end
end
