require 'spec_helper'

describe DurationHelper do
  describe '#duration_for' do
    it 'displays duration in correct format' do
      v1 = 7200
      v2 = 3599
      duration_for_v1 = helper.duration_for(v1)
      duration_for_v2 = helper.duration_for(v2)

      expect(duration_for_v1).to eq '2:00:00'
      expect(duration_for_v2).to eq '59:59'
    end
  end
end