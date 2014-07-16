class TimestampsToTimestamptz < ActiveRecord::Migration
  def change
    execute <<SQL
DROP MATERIALIZED VIEW posts_by_dow;
DROP MATERIALIZED VIEW posts_by_hod;
DROP MATERIALIZED VIEW posts_by_hour;
DROP MATERIALIZED VIEW user_posts_by_dow;
DROP MATERIALIZED VIEW user_posts_by_hod;
DROP MATERIALIZED VIEW user_posts_by_hour;
SET TIME ZONE 'UTC';
ALTER TABLE posts ALTER COLUMN remote_created_at TYPE timestamptz;
ALTER TABLE topics ALTER COLUMN last_post_remote_created_at TYPE timestamptz;
ALTER TABLE users ALTER COLUMN avatar_updated_at TYPE timestamptz;
SET TIME ZONE 'Europe/Ljubljana';
CREATE MATERIALIZED VIEW posts_by_dow AS
  SELECT date_trunc('day', remote_created_at)::date AS day,
         date_part('isodow', remote_created_at)::integer AS dow,
         count(*) AS posts_count
  FROM posts
  GROUP BY day, dow
WITH NO DATA;
CREATE MATERIALIZED VIEW user_posts_by_dow AS
  SELECT user_id,
         date_trunc('day', remote_created_at)::date AS day,
         date_part('isodow', remote_created_at)::integer AS dow,
         count(*) AS posts_count
  FROM posts
  GROUP BY user_id, day, dow
WITH NO DATA;
CREATE MATERIALIZED VIEW posts_by_hod AS
  SELECT date_trunc('day', remote_created_at)::date AS day,
         date_part('hour', remote_created_at)::integer AS hod,
         count(*) AS posts_count
  FROM posts
  GROUP BY day, hod
WITH NO DATA;
CREATE MATERIALIZED VIEW user_posts_by_hod AS
  SELECT user_id,
         date_trunc('day', remote_created_at)::date AS day,
         date_part('hour', remote_created_at)::integer AS hod,
         count(*) AS posts_count
  FROM posts
  GROUP BY user_id, day, hod
WITH NO DATA;
CREATE MATERIALIZED VIEW posts_by_hour AS
  SELECT date_trunc('hour', remote_created_at) AS hour,
         count(*) AS posts_count
  FROM posts
  GROUP BY hour
WITH NO DATA;
CREATE MATERIALIZED VIEW user_posts_by_hour AS
  SELECT user_id,
         date_trunc('hour', remote_created_at) AS hour,
         count(*) AS posts_count
  FROM posts
  GROUP BY user_id, hour
WITH NO DATA;
ALTER TABLE posts DROP CONSTRAINT remote_id_not_null_post_legacy;
ALTER TABLE posts ADD CONSTRAINT remote_id_not_null_post_legacy CHECK (
  remote_created_at AT TIME ZONE 'UTC' <= timestamp '2013-02-03 13:12:55' OR
  remote_id IS NOT NULL
)
SQL
  end
end
