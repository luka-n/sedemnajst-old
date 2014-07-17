class TimestampsForAll < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE users ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
      ALTER TABLE users ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
      ALTER TABLE posts ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
      ALTER TABLE posts ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
      ALTER TABLE topics ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
      ALTER TABLE topics ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
    SQL
  end

  def down
    remove_column :users, :created_at
    remove_column :users, :updated_at
    remove_column :posts, :created_at
    remove_column :posts, :updated_at
    remove_column :topics, :created_at
    remove_column :topics, :updated_at
  end
end
