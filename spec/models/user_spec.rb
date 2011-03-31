require 'spec_helper'

def add_user(name)
  User.create({
    :login => name.to_s,
    :email => "#{name}@pixnet.net",
    :nickname => name.to_s,
    :identity_url => "https://openid.pixnet.cc/u/#{name}"
  })
end

describe User do

  before do
    @user = add_user('manic')
  end

  it "should create from PIXNET OpenID hash" do
    registration = {
      "email" => "manictest1@pixnet.net",
      "nickname" => "沒力小僧修道人"
    }
    identity_url = "https://openid.pixnet.cc/u/manictest1/"

    user = User.create_from_pixnet_openid(registration, identity_url)
    user.login.should == "manictest1"
    user.email.should == "manictest1@pixnet.net"
    user.nickname.should == "沒力小僧修道人"
    user.identity_url.should == "https://openid.pixnet.cc/u/manictest1"

  end

  it "pixnet_link will return user's link in PIXNET" do
    # manic has custom domain: http://www.manic.tw
    @user.pixnet_link.should == 'http://www.manic.tw'
  end

  it "verify_token will check parameter valid with generate_token" do
    # verify_token from generate_token
    @user.verify_token(@user.generate_token).should be_true
  end

  it "should have assistances" do
    # default has no assistances
    @user.assistances.size.should == 0
  end

  it "should have an assistance after call add_assistant method" do
    @user.add_assistant("manictest1")
    @user.assistances.size.should == 1
  end

  it "should return true or flase if has_assistant?(name) called" do
    @user.add_assistant("manictest1")
    @user.has_assistant?("manictest1").should be_true
    @user.has_assistant?("manicasdf").should be_false
  end

  it "should remove assistant if remove_assistant?(name) called" do
    @user.add_assistant("manictest1")
    @user.remove_assistant("manictest1").should be_true
    @user.has_assistant?("manictest1").should be_false
  end

end
