# == Schema Information
# Schema version: 20110330092315
#
# Table name: assistances
#
#  id                :integer(4)      not null, primary key
#  master_id         :integer(4)
#  assistant_name    :string(32)
#  assistant_id      :integer(4)      default(0)
#  perm_blog_comment :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#

class Assistance < ActiveRecord::Base

  belongs_to :master, :class_name => "User"
  belongs_to :assistant, :class_name => "User", :conditions => ['assistant_id != ?', 0]

  scope :named, lambda { |name| where(:assistant_name => name.to_s) }

  validates_presence_of :master_id
  validates_format_of :assistant_name, :with => /^[0-9a-zA-Z]+$/i, :on => :create
  validates_each :assistant_name do |record, attr, value|
    begin
      open("http://emma.pixnet.cc/users/#{value.to_s}")
    rescue
      record.errors.add attr, '不是 PIXNET 的使用者'
    end
  end

  def assistant_name=(value)
    write_attribute :assistant_name, (value ? value.downcase : nil)
  end
end
