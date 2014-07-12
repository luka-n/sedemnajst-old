class PostsByDow < ActiveRecord::Base
  self.table_name = :posts_by_dow

  class << self
    def series(options={})
      between_maybe = if (between = options[:between])
                        "WHERE day BETWEEN '#{between.min}' AND '#{between.max}'"
                      else
                        ""
                      end
      data = connection.execute <<SQL
WITH series AS (
  SELECT DISTINCT generate_series(1, 7) AS dow,
                  0 AS posts_count
  FROM posts_by_dow
  #{between_maybe}
),
counts AS (
  SELECT dow, sum(posts_count) AS posts_count
  FROM posts_by_dow
  #{between_maybe}
  GROUP BY dow
)
SELECT series.dow,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.dow = series.dow
ORDER BY series.dow
SQL
      data.map { |i| i["posts_count"].to_i }
    end
  end
end
