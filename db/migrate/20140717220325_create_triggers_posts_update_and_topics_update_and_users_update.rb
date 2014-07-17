# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersPostsUpdateAndTopicsUpdateAndUsersUpdate < ActiveRecord::Migration
  def up
    create_trigger("posts_before_update_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        before(:update) do
      "NEW.updated_at := now();"
    end

    create_trigger("topics_before_update_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        before(:update) do
      "NEW.updated_at := now();"
    end

    create_trigger("users_before_update_row_tr", :generated => true, :compatibility => 1).
        on("users").
        before(:update) do
      "NEW.updated_at := now();"
    end
  end

  def down
    drop_trigger("posts_before_update_row_tr", "posts", :generated => true)

    drop_trigger("topics_before_update_row_tr", "topics", :generated => true)

    drop_trigger("users_before_update_row_tr", "users", :generated => true)
  end
end
