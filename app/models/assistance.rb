# == Schema Information
# Schema version: 20110330092315
#
# Table name: assistances
#
#  id                :integer(4)      not null, primary key
#  master_id         :integer(4)
#  assistant_name    :string(32)
#  assistant_id      :string(255)     default("0")
#  perm_blog_comment :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#

class Assistance < ActiveRecord::Base
end
