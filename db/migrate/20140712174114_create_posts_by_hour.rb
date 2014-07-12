class CreatePostsByHour < ActiveRecord::Migration
  def up
    execute <<SQL
CREATE MATERIALIZED VIEW posts_by_hour AS
  SELECT date_trunc('hour', remote_created_at) AS hour,
         count(*) AS posts_count
  FROM posts
  GROUP BY hour
WITH NO DATA
SQL
  end

  def down
    execute "DROP MATERIALIZED VIEW posts_by_hour"
  end
end
