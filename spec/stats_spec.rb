require 'spec_helper'
require CurrentDir + '/lib/devpanel/stats.rb'

describe DevPanel::Stats do
  let(:stats) { described_class }
  let!(:data) { stats.data }
  let(:values) { { 'left' => 10, 'top' => 11, 'visible' => 'true', 'zindex' => 50000 } }

  before(:each) do
    stats.set_defaults
  end

  context '#data' do
    it 'has an initial value' do
      expect(data).to eql({:log=>''})
    end

    it 'allows you to set values to data' do
      data[:sample_value] = '22'
      expect(data).to eql({:log=>'', :sample_value=>'22'})
    end
  end

  context '#left' do
    it 'has an initial value' do
      expect(stats.left).to eql(0)
    end

    it 'you can set the intial value ' do
      stats.set_by_params(values)
      expect(stats.left).to eql(10)
    end
  end

  context '#top' do
    it 'has an initial value' do
      expect(stats.top).to eql(0)
    end

    it 'you can set the intial value ' do
      stats.set_by_params(values)
      expect(stats.top).to eql(11)
    end
  end

  context '#zindex' do
    it 'has an initial value' do
      expect(stats.zindex).to eql(1000)
    end

    it 'you can set the intial value ' do
      stats.set_by_params(values)
      expect(stats.zindex).to eql(50000)
    end
  end
end