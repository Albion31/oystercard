require 'journey_log'

describe JourneyLog do
  describe "#initialize" do
    it "should initialize with an empty journey log" do
      log = JourneyLog.new
      expect(log.journey_list).to eq []
    end
  end
end
