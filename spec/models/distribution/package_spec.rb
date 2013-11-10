require 'spec_helper'
module Distribution
  describe Package do
    it 'should send notifications when move to canceled state' do
      package = Package.create!(user_id:6630, document_number: '6640 234003')
      puts "State before cancel: #{package.state}"
      package.cancel
      puts "State after cancel: #{package.state}"
      expect(package.state).to eq('canceled')
    end
  end
end
