require 'journey'

describe Journey do

  let(:station) {double(:station)}

  describe "#start" do

    it "should record allow to call the entry station" do
      subject.start(station)
      expect(subject.entry_station).to eq station
    end
  end

  describe "#end" do

    it "should record allow to call the entry station" do
      subject.end(station)
      expect(subject.exit_station).to eq station
    end
  end

  describe "#fare" do
    it {is_expected.to respond_to(:fare)}

    it "should charge the correct fare for complete journeys" do
      subject.start(station)
      subject.end(station)
      expect(subject.fare).to eq Journey::MINIMUM_FARE
    end

    it "should charge a penalty fare for incomplete journey" do
      subject.end(station)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end
end
