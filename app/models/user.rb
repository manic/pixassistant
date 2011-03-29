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
    begin
      ret = parse_pixnet_info
    rescue
    else
      return ret["user"]["link"] if ret.is_a?(Hash) && !ret["user"]["link"].empty?
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

  def parse_pixnet_info
    require 'open-uri'
    return JSON.parse(open("https://emma.pixnet.cc/users/#{login}").read)
  end

  protected
  def service(name)
    return "#{pixnet_link}/#{name}"
  end

end
