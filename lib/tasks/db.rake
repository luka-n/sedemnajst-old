namespace :db do
  task refresh_materialized_views: :environment do
    %w{user_posts_by_hour user_posts_by_dow user_posts_by_hod
       posts_by_hour posts_by_dow posts_by_hod}.each do |view|
      ActiveRecord::Base.connection.execute "REFRESH MATERIALIZED VIEW #{view}"
    end
  end
end
