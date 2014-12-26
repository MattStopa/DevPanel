require 'spec_helper'
require CurrentDir + '/lib/devpanel/stats.rb'

describe DevPanel::Stats do
  context '#data' do
    it 'has an initial value' do
      stats = described_class.data
      expect(stats).to eql({:log=>''})
    end
  end
end