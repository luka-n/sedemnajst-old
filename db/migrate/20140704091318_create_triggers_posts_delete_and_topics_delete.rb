# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersPostsDeleteAndTopicsDelete < ActiveRecord::Migration
  def up
    create_trigger("posts_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:delete) do
      <<-SQL_ACTIONS
      UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
      UPDATE topics SET posts_count = posts_count - 1 WHERE id = OLD.topic_id;
      IF (OLD.remote_id IS NOT NULL AND OLD.remote_id =
          (SELECT last_post_remote_id FROM topics WHERE id = OLD.topic_id)) OR
           OLD.remote_created_at =
            (SELECT last_post_remote_created_at
             FROM topics WHERE id = OLD.topic_id) THEN
        UPDATE topics
        SET last_post_remote_created_at = last_posts.remote_created_at,
            last_post_remote_id = last_posts.remote_id
        FROM (
          SELECT max(remote_created_at) AS remote_created_at,
                 max(remote_id) AS remote_id
          FROM posts
          WHERE topic_id = OLD.topic_id
        ) AS last_posts
        WHERE id = OLD.topic_id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("topics_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:delete) do
      "UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;"
    end
  end

  def down
    drop_trigger("posts_after_delete_row_tr", "posts", :generated => true)

    drop_trigger("topics_after_delete_row_tr", "topics", :generated => true)
  end
end
