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

  context '#invalid_number?' do
    it 'returns true if the class is not a number' do
      expect(stats.invalid_number?('aaa')).to eql(true)
    end

    it 'returns true if the class is nil' do
      expect(stats.invalid_number?(nil)).to eql(true)
    end

    it 'returns false if the class is a number' do
      expect(stats.invalid_number?(2)).to eql(false)
    end
  end

  context '#log' do
    it 'returns logged data if nothing is passed in' do
      stats.log('20')
      expect(stats.log).to eql("<div style='border-bottom: 1px black solid'>20</div>")
    end

    it 'logs one item' do
      stats.log('10')
      expect(stats.log).to eql("<div style='border-bottom: 1px black solid'>10</div>")
    end

    it 'logs multiple items' do
      stats.log('10')
      stats.log('22')
      expect(stats.log).to eql("<div style='border-bottom: 1px black solid'>10</div>" +
        "<div style='border-bottom: 1px black solid'>22</div>")
    end
  end

  context '#set_by_params' do
    it 'sets the all properties when a hash is passed in' do
      stats.set_by_params({'left' => 55, 'top' => 22, 'visible' => false, 'zindex' => 0})
      expect(stats.left).to eql(55)
      expect(stats.top).to eql(22)
      expect(stats.visible).to eql('false')
      expect(stats.zindex).to eql(0)
    end

    it 'doesnt affect anything if wrong params are passed in' do
      stats.set_by_params({'banana' => 44444})
      expect(stats.left).to eql(0)
      expect(stats.top).to eql(0)
      expect(stats.visible).to eql('false')
      expect(stats.zindex).to eql(1000)
    end
  end

  context '#show?' do
    it 'shows false by default' do
      expect(stats.show?).to eql(false)
    end

    it 'to be true if set to show' do
      stats.set_by_params({'visible' => 'true'})
      expect(stats.show?).to eql(true)
    end
  end

  context '#time' do
    it 'should log how long an action took' do
      stats.time { sleep(1) }
      expect(stats.log).to include('Time Elapsed: 1000')
    end

    it 'should allow tagging a time trial' do
      stats.time('first') { sleep(1) }
      expect(stats.log).to include('first')
    end
  end
end