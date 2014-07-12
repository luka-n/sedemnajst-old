namespace :db do
  task refresh_materialized_views: :environment do
    ActiveRecord::Base.connection.
      execute "REFRESH MATERIALIZED VIEW user_posts_by_hour"
    ActiveRecord::Base.connection.
      execute "REFRESH MATERIALIZED VIEW user_posts_by_dow"
    ActiveRecord::Base.connection.
      execute "REFRESH MATERIALIZED VIEW user_posts_by_hod"
  end
end
