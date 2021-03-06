require_relative 'journey_log'
require_relative 'station'
class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :journey_log, :current_journey
  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journey_log = JourneyLog.new
  end

  def add_money(amount)
    raise "The balance limit is #{BALANCE_LIMIT} pounds" if over_limit?(amount)
    @balance += amount
  end

  def touch_in(entry_station, journey = Journey.new)
    raise 'Insufficient Funds!' if insufficient_funds?
    if in_journey?
      deduct(@current_journey.fare)
      @current_journey.end(nil)
      log_journey
    else
      @current_journey = journey
      @current_journey.start(entry_station)
    end
  end

  def touch_out(exit_station)
    if in_journey?
      @current_journey.end(exit_station)
      deduct(@current_journey.fare)
    else
      start_invalid_journey
      deduct(@current_journey.fare)
      @current_journey.end(exit_station)
    end
    log_journey
  end

  def in_journey?
    !@current_journey.nil?
  end

  def log_journey
    journey_log.journey_list << @current_journey
    @current_journey = nil
  end

  def start_invalid_journey
    @current_journey = Journey.new
    @current_journey.start(nil)
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def over_limit?(amount)
    (@balance + amount) > BALANCE_LIMIT
  end

  def insufficient_funds?
    @balance < MINIMUM_FARE
  end
end
