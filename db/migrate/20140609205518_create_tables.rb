class CreateTables < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name, null: false
      t.integer :remote_id, null: false
      t.integer :posts_count, null: false, default: 0
      t.integer :topics_count, null: false, default: 0

      t.attachment :avatar

      t.index :remote_id, unique: true
    end

    create_table :topics do |t|
      t.string :title, null: false
      t.integer :user_id, null: true
      t.integer :remote_id, null: false
      t.integer :posts_count, null: false, default: 0
      t.datetime :last_post_remote_created_at, null: true
      t.integer :last_post_remote_id, null: true
      t.datetime :remote_created_at, null: false

      t.index :user_id
      t.index :remote_id, unique: true
      t.index :last_post_remote_created_at
      t.index :last_post_remote_id
    end
    add_foreign_key :topics, :users

    create_table :posts do |t|
      t.text :body, null: false
      t.integer :topic_id, null: false
      t.integer :user_id, null: true
      t.datetime :remote_created_at, null: false
      t.integer :remote_id, null: true

      t.index :topic_id
      t.index :user_id
      t.index :remote_created_at
      t.index :remote_id, unique: true
    end
    execute <<SQL
ALTER TABLE posts
ADD CONSTRAINT remote_id_not_null_post_legacy
CHECK (
  remote_created_at <= timestamp '2013-02-03 13:14:30' OR
  remote_id IS NOT NULL
)
SQL
    add_foreign_key :posts, :topics
    add_foreign_key :posts, :users
  end

  def down
    drop_table :users
    drop_table :topics
    drop_table :posts
  end
end
