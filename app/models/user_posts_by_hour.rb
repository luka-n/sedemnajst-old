class UserPostsByHour < ActiveRecord::Base
  self.table_name = :user_posts_by_hour

  belongs_to :user

  class << self
    def time_series_for(user)
      find_by_sql [<<SQL, user.id, user.id]
WITH series AS (
  SELECT user_id,
         generate_series(min(hour), max(hour), '1 hour') AS hour,
         0 AS posts_count
  FROM user_posts_by_hour
  WHERE user_id = ?
  GROUP BY user_id
),
counts AS (
  SELECT hour, posts_count
  FROM user_posts_by_hour
  WHERE user_id = ?
)
SELECT series.user_id,
       series.hour,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.hour = series.hour
ORDER BY series.hour
SQL
    end
  end
end
