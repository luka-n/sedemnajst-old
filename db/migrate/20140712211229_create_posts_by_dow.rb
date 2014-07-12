class CreatePostsByDow < ActiveRecord::Migration
  def up
    execute <<SQL
CREATE MATERIALIZED VIEW posts_by_dow AS
  SELECT date_trunc('day', remote_created_at) AS day,
         date_part('dow', remote_created_at) AS dow,
         count(*) AS posts_count
  FROM posts
  GROUP BY day, dow
WITH NO DATA
SQL
  end

  def down
    execute "DROP MATERIALIZED VIEW posts_by_dow"
  end
end
