class PostsByHod < ActiveRecord::Base
  self.table_name = :posts_by_hod

  class << self
    def series(options={})
      between_maybe = if (between = options[:between])
                        "WHERE day BETWEEN '#{between.min}' AND '#{between.max}'"
                      else
                        ""
                      end
      data = connection.execute <<SQL
WITH series AS (
  SELECT DISTINCT generate_series(0, 23) AS hod,
                  0 AS posts_count
  FROM posts_by_hod
  #{between_maybe}
),
counts AS (
  SELECT hod, sum(posts_count) AS posts_count
  FROM posts_by_hod
  #{between_maybe}
  GROUP BY hod
)
SELECT series.hod,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.hod = series.hod
ORDER BY series.hod
SQL
      data.map { |i| i["posts_count"].to_i }
    end
  end
end
