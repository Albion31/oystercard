require 'journey'

describe Journey do
  let(:entry_station) { double(:entry_station, zone: 1) }
  let(:exit_station) { double(:exit_station, zone: 2) }

  describe '#start' do
    it 'should record allow to call the entry station' do
      subject.start(entry_station)
      expect(subject.entry_station).to eq entry_station
    end
  end

  describe '#end' do
    it 'should record allow to call the entry station' do
      subject.end(exit_station)
      expect(subject.exit_station).to eq exit_station
    end
  end

  describe '#fare' do
    it { is_expected.to respond_to(:fare) }

    it 'should charge the correct fare for complete journeys' do
      subject.start(entry_station)
      subject.end(exit_station)
      expect(subject.fare).to eq 2
    end

    it 'should charge a penalty fare for incomplete journey' do
      subject.end(entry_station)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end
end
