namespace :db do
  task refresh_materialized_views: :environment do
    ActiveRecord::Base.connection.
      execute "REFRESH MATERIALIZED VIEW user_posts_by_hour"
  end
end
