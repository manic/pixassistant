require 'spec_helper'

def add_user(name)
  User.create({
    :login => name.to_s,
    :email => "#{name}@pixnet.net",
    :nickname => name.to_s,
    :identity_url => "https://openid.pixnet.cc/u/#{name}"
  })
end

describe Assistance do

  before do
    @user = add_user('manic')
  end

  it "fails validation with no assistant_name" do
    Assistance.new.should have(2).error_on(:assistant_name) # empty and no such user
  end

  it "fails validation with no master_id" do
    Assistance.new.should have(1).error_on(:master_id)
  end

  it "fails validation with valid assistant_name but no such user" do
    # "www" is not a valid account name in PIXNET so there is no such user.
    Assistance.new(:assistant_name => "www").should have(1).error_on(:assistant_name)
  end

  it "passes validation with correct assistant_name" do
    Assistance.new(:assistant_name => "manic").should have(:no).error_on(:assistant_name)
  end

  it "passes validation with master_id" do
    Assistance.new(:master_id => 1).should have(:no).error_on(:master_id)
  end

end
