require 'rspec'

describe Member do

  it 'should find correct user from ogromno forum db' do
    member = Member.find(user: 'lopinopulos')
    puts member.inspect
    member.is_a? Hash should be_true
  end
end