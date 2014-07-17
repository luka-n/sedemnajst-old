# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersPostsUpdateAndTopicsUpdate < ActiveRecord::Migration
  def up
    create_trigger("posts_after_update_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:update) do
      <<-SQL_ACTIONS
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("topics_after_update_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:update) do
      <<-SQL_ACTIONS
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
      END IF;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("posts_after_update_row_tr", "posts", :generated => true)

    drop_trigger("topics_after_update_row_tr", "topics", :generated => true)
  end
end
