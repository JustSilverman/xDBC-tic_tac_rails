require 'spec_helper'

describe User do
  context 'validations' do
    let!(:user) { create(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should_not allow_value("blah").for(:email) }
    it { should allow_value("a@b.com").for(:email) }
    it { should validate_confirmation_of(:password) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
  end

  context 'authentication' do 
    let!(:user) { create(:user) }
    
    it 'logs in with the correct password' do
      expect {
        user.authenticate("password")
      }.to be_true
    end

    it 'can not log in with the incorrect password' do
      expect {
        user.authenticate("notpassword")
      }.to be_true
    end
  end
end
