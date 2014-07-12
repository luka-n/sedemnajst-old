class UserPostsByDow < ActiveRecord::Base
  self.table_name = :user_posts_by_dow

  belongs_to :user

  class << self
    def series_for(user, options={})
      between_maybe = if (between = options[:between])
                        "AND day BETWEEN '#{between.min}' AND '#{between.max}'"
                      else
                        ""
                      end
      data = connection.execute <<SQL
WITH series AS (
  SELECT DISTINCT user_id,
                  generate_series(1, 7) AS dow,
                  0 AS posts_count
  FROM user_posts_by_dow
  WHERE user_id = #{user.id} #{between_maybe}
),
counts AS (
  SELECT user_id, dow, sum(posts_count) AS posts_count
  FROM user_posts_by_dow
  WHERE user_id = #{user.id} #{between_maybe}
  GROUP BY user_id, dow
)
SELECT series.user_id,
       series.dow,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.dow = series.dow
ORDER BY series.dow
SQL
      data.map { |i| i["posts_count"].to_i }
    end
  end
end
