class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.integer :user_id
      t.string  :image
      t.string  :url
      t.integer :position
      t.timestamps
    end
    add_index :banners, :user_id
  end

  def self.down
    drop_table :banners
  end
end
