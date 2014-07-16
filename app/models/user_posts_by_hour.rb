class UserPostsByHour < ActiveRecord::Base
  self.table_name = :user_posts_by_hour

  belongs_to :user

  class << self
    def series_for(user)
      data = connection.execute <<SQL
WITH series AS (
  SELECT user_id,
         generate_series(min(hour), date_trunc('hour', now()), '1 hour') AS hour,
         0 AS posts_count
  FROM user_posts_by_hour
  WHERE user_id = #{user.id}
  GROUP BY user_id
),
counts AS (
  SELECT hour, posts_count
  FROM user_posts_by_hour
  WHERE user_id = #{user.id}
)
SELECT series.user_id,
       date_part('epoch', series.hour) * 1000 AS hour,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.hour = series.hour
ORDER BY series.hour
SQL
      data.map { |i| [i["hour"].to_i, i["posts_count"].to_i] }
    end
  end
end
