class MakeUsernameIndexCaseInsensitive < ActiveRecord::Migration
  def change
    execute <<SQL
DROP INDEX index_users_on_name;
CREATE UNIQUE INDEX index_users_on_name ON users (lower(name));
SQL
  end
end
