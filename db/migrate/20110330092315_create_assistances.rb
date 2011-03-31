class CreateAssistances < ActiveRecord::Migration
  def self.up
    create_table :assistances do |t|

      t.integer :master_id
      t.string  :assistant_name, :limit => 32
      t.integer :assistant_id, :default => 0
      t.boolean :perm_blog_comment, :default => false

      t.timestamps
    end

    add_index :assistances, :master_id
    add_index :assistances, :assistant_id
    add_index :assistances, :assistant_name
    add_index :assistances, [:master_id, :assistant_name], :unique => true
    add_index :assistances, [:master_id, :assistant_id]
  end

  def self.down
    drop_table :assistances
  end
end
