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

  describe '#duration_in_minutes' do
    it 'displays duration in correct format' do
      v1 = 59
      v2 = 61
      v3 = 119
      duration_for_v1 = helper.duration_in_minutes(v1)
      duration_for_v2 = helper.duration_in_minutes(v2)
      duration_for_v3 = helper.duration_in_minutes(v3)

      expect(duration_for_v1).to eq '1 minute'
      expect(duration_for_v2).to eq '1 minute'
      expect(duration_for_v3).to eq '2 minutes'
    end
  end

  describe '#duration_in_hours' do
    it 'displays duration in correct format' do
      v1 = 7200
      v2 = 1799
      duration_for_v1 = helper.duration_in_hours(v1)
      duration_for_v2 = helper.duration_in_hours(v2)

      expect(duration_for_v1).to eq '2 hours'
      expect(duration_for_v2).to eq '30 minutes'
    end
  end
end
