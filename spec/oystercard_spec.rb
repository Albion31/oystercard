require 'oystercard.rb'

describe Oystercard do
  it { is_expected.to respond_to(:add_money).with(1).argument }
  it { is_expected.to respond_to(:touch_in).with(1).argument }
  it { is_expected.to respond_to(:touch_out).with(1).argument }
  it { is_expected.to respond_to(:log) }

  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }

  ADD_MONEY = 60
  TEST_DEDUCT_MONEY = 2

  describe '#initalize' do
    it 'should check that the card has an empty list of journey by default' do
      expect(subject.log).to be_empty
    end
  end

  describe '#balance' do
    it 'has no money initially' do
      expect(subject.balance).to eq 0
    end

    it 'can be loaded with money' do
      expect { subject.add_money(ADD_MONEY) }.to change { subject.balance }.by ADD_MONEY
    end

    it "has a balance limit of #{Oystercard::BALANCE_LIMIT} Pounds" do
      subject.add_money(ADD_MONEY)
      expect { subject.add_money(ADD_MONEY) }.to raise_error "The balance limit is #{Oystercard::BALANCE_LIMIT} pounds"
    end
  end

  describe '#touch in' do
    it 'can touch in when entering the tube' do
      subject.add_money(ADD_MONEY)
      subject.touch_in(entry_station)
      expect(subject.in_journey?).to be true
    end

    it 'cannot touch in with insufficient funds' do
      expect { subject.touch_in(entry_station) }.to raise_error 'Insufficient Funds!'
    end

    it "should raise error if you touch in without touching out" do
      subject.add_money(50)
      subject.touch_in(entry_station)
      expect{ subject.touch_in(entry_station)}.to raise_error "You did not touch out"
    end

    describe '#touch out' do
      before do
        subject.add_money(ADD_MONEY)
        subject.touch_in(entry_station)
      end

      it 'no longer in a journey after touching out' do
        subject.touch_out(exit_station)
        expect(subject.in_journey?).to be false
      end

      it 'deduces a fare when tapping out' do
        expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
      end

      it 'should store exit station' do
        subject.touch_out(exit_station)
        expect(subject.exit_station).to eq exit_station
      end

      it "should raise error when you touch out without touching in" do
        subject.touch_out(exit_station)
        expect{subject.touch_out(exit_station)}.to raise_error "You have not touched in a station first"
      end
    end
  end

  describe 'stores information about travel' do
    before do
      subject.add_money(ADD_MONEY)
      subject.touch_in(entry_station)
    end

    it 'remembers the station it was last tapped at' do
      expect(subject.entry_station).to eq entry_station
    end

    it 'forgets entry station upon touching out' do
      expect { subject.touch_out(exit_station) }.to change { subject.entry_station }.to be nil
    end

    it 'should store a journey' do
      subject.touch_out(exit_station)
      expect(subject.log[-1]).to eq ({ entry_station: entry_station, exit_station: exit_station})
    end
  end
end
