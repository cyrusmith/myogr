require 'spec_helper'

describe User do
  before(:all) do
    @user = User.find 6630
    @role = Role.find_by_name(:admin)
    @user.add_role :salon_admin
  end
  it 'should return true for existing roles by name' do
    @user.has_role?(:admin).should be_true
  end
  it 'should return true for existing roles by object' do
    @user.has_role?(@role).should be_true
  end
  it 'should return false for non existing role' do
    new_role = Role.create(name: :new_role)
    @user.has_role?(new_role)
  end
  it 'should add new role to user correctly' do
    @user.has_role?(:salon_admin).should be_true
  end
  it 'should not add role second time' do
    @user.add_role :salon_admin
    @user.add_role :salon_admin
    Role.where(name: :salon_admin).count.eql?(1)
  end
end
