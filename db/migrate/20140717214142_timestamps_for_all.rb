class TimestampsForAll < ActiveRecord::Migration
  def up
    add_column :users, :created_at, :timestamp, null: false
    add_column :users, :updated_at, :timestamp, null: false
    add_column :posts, :created_at, :timestamp, null: false
    add_column :posts, :updated_at, :timestamp, null: false
    add_column :topics, :created_at, :timestamp, null: false
    add_column :topics, :updated_at, :timestamp, null: false
    execute <<-SQL
      ALTER TABLE users ALTER COLUMN created_at SET DEFAULT now();
      ALTER TABLE users ALTER COLUMN updated_at SET DEFAULT now();
      ALTER TABLE posts ALTER COLUMN created_at SET DEFAULT now();
      ALTER TABLE posts ALTER COLUMN updated_at SET DEFAULT now();
      ALTER TABLE topics ALTER COLUMN created_at SET DEFAULT now();
      ALTER TABLE topics ALTER COLUMN updated_at SET DEFAULT now();
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
