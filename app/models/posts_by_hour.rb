class PostsByHour < ActiveRecord::Base
  self.table_name = :posts_by_hour

  class << self
    def series
      data = connection.execute <<SQL
WITH series AS (
  SELECT generate_series(min(hour), date_trunc('hour', now()), '1 hour') AS hour,
         0 AS posts_count
  FROM posts_by_hour
),
counts AS (
  SELECT hour, posts_count
  FROM posts_by_hour
)
SELECT date_part('epoch', series.hour) * 1000 AS hour,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.hour = series.hour
ORDER BY series.hour
SQL
      data.map { |i| [i["hour"].to_i, i["posts_count"].to_i] }
    end
  end
end
