class CreateOauthConsumerTokens < ActiveRecord::Migration
  def self.up

    create_table :consumer_tokens do |t|
      t.integer :user_id
      t.string :type, :limit => 30
      t.string :token, :limit => 32 # This has to be huge because of Yahoo's excessively large tokens
      t.string :secret, :limit => 32
      t.timestamps
    end

    add_index "consumer_tokens", ["token"], :name => "token", :unique => true
    add_index :consumer_tokens, :user_id

  end

  def self.down
    drop_table :consumer_tokens
  end

end
