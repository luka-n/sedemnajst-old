class CreatePasswordRequests < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :password_request_token
      t.datetime :password_requested_at
      t.index :password_request_token, unique: true
    end
  end

  def down
    change_table :users do |t|
      t.remove :password_request_token
      t.remove :password_requested_at
    end
  end
end
