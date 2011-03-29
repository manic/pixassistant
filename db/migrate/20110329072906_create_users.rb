class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :nickname
      t.string :identity_url

      t.timestamps
    end
    add_index :users, :login, :unique => true
    add_index :users, :identity_url, :unique => true
  end

  def self.down
    drop_table :users
  end
end
