# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersPostsInsertAndTopicsInsert < ActiveRecord::Migration
  def up
    create_trigger("posts_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:insert) do
      <<-SQL_ACTIONS
      UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
      UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                        last_post_remote_id = NEW.remote_id
      WHERE id = NEW.topic_id;
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end

    create_trigger("topics_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:insert) do
      "UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;"
    end
  end

  def down
    drop_trigger("posts_after_insert_row_tr", "posts", :generated => true)

    drop_trigger("topics_after_insert_row_tr", "topics", :generated => true)
  end
end
