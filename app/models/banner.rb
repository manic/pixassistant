class Banner < ActiveRecord::Base
  belongs_to :user
  acts_as_list :scope => :user

  default_scope order(:position)
end
