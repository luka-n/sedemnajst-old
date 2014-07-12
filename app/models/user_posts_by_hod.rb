class UserPostsByHod < ActiveRecord::Base
  self.table_name = :user_posts_by_hod

  belongs_to :user

  class << self
    def series_for(user, options={})
      between_maybe = if (between = options[:between])
                        "AND hour BETWEEN '#{between.min}' AND '#{between.max}'"
                      else
                        ""
                      end
      data = connection.execute <<SQL
WITH series AS (
  SELECT DISTINCT user_id,
                  generate_series(0, 23) AS hod,
                  0 AS posts_count
  FROM user_posts_by_hod
  WHERE user_id = #{user.id} #{between_maybe}
),
counts AS (
  SELECT user_id, hod, sum(posts_count) AS posts_count
  FROM user_posts_by_hod
  WHERE user_id = #{user.id} #{between_maybe}
  GROUP BY user_id, hod
)
SELECT series.user_id,
       series.hod,
       coalesce(counts.posts_count, series.posts_count) AS posts_count
FROM series
LEFT JOIN counts ON counts.hod = series.hod
ORDER BY series.hod
SQL
      data.map { |i| i["posts_count"].to_i }
    end
  end
end
