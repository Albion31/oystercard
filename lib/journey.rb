
class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def start(station)
    @complete = is_the_journey_complete?
    @entry_station = station
  end

  def end(station)
    @exit_station = station
    @complete = is_the_journey_complete?
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY_FARE
  end

  def complete?
    @complete
  end

  def is_the_journey_complete?
    !@entry_station.nil? && !@exit_station.nil?
  end
end
