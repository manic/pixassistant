# == Schema Information
# Schema version: 20110330092315
#
# Table name: users
#
#  id           :integer(4)      not null, primary key
#  login        :string(255)
#  email        :string(255)
#  nickname     :string(255)
#  identity_url :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class User < ActiveRecord::Base
  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 3..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  attr_accessible :login, :email, :nickname, :identity_url

  has_one  :pixnet, :class_name => "PixnetToken", :dependent=>:destroy
  has_many :assistances, :foreign_key => :master_id

  def self.create_from_pixnet_openid(registration, identity_url)
    User.new.tap do |user|
      user.login = registration["email"].gsub("@pixnet.net", "")
      user.email = registration["email"]
      user.nickname = registration["nickname"]
      user.identity_url = identity_url.gsub(%r{/$},'')
      user.save!
    end
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def pixnet_link
    return @pixnet_link if @pixnet_link
    begin
      ret = parse_pixnet_info
    rescue
    else
      if ret.is_a?(Hash) && !ret["user"]["link"].empty?
        @pixnet_link = ret["user"]["link"]
        return @pixnet_link
      end
    end

    return "http://#{login}.pixnet.net"
  end

  def generate_token
    return Digest::MD5.hexdigest(login)
  end

  def verify_token(token)
    return token == generate_token
  end

  def blog
    service("blog")
  end

  def album
    service("album")
  end

  def guestbook
    service("guestbook")
  end

  def profile
    service("profile")
  end

  def add_assistant(user)
    self.assistances.create({
      :assistant_name => user
    })
  end

  def has_assistant?(user)
    assistant = self.assistances.named(user).first
    return assistant.present?
  end

  def remove_assistant(user)
    assistant = self.assistances.named(user).first
    assistant.destroy
    self.reload
    return true
  end

  def get_masters
    masters = Assistance.where(:assistant_name => self.login).map { |c| c.master }
    (masters << self).uniq
  end

  protected
  def service(name)
    return "#{pixnet_link}/#{name}"
  end

  def parse_pixnet_info
    return JSON.parse(open("http://emma.pixnet.cc/users/#{login}").read)
  end


end
