require 'spec_helper'

describe TimestampHelper do
  describe '#timestamp' do
    it 'returns the creation time in correct format' do
      resource = Course.new(created_at: '2016-01-01 09:09:09')

      timestamp = helper.timestamp(resource)

      expect(timestamp).to eq('Jan  1, 2016')
    end
  end
end
