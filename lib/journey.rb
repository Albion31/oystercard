
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
    !@entry_station.nil? && !@exit_station.nil? ? compare_zones * MINIMUM_FARE : PENALTY_FARE
  end

  def compare_zones
    (@entry_station.zone - @exit_station.zone).abs + 1
  end

  def complete?
    @complete
  end

  def is_the_journey_complete?
    !@entry_station.nil? && !@exit_station.nil?
  end
end
