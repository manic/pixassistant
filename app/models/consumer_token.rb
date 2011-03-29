require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token

  belongs_to :user

end
# == Schema Information
#
# Table name: consumer_tokens
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  type       :string(30)
#  token      :string(32)
#  secret     :string(32)
#  created_at :datetime
#  updated_at :datetime
#

