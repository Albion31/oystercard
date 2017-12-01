class JourneyLog

  attr_accessor :journey_list

  def initialize
    @journey_list = []
  end
  #
  # def start_journey
  #   if in_journey?
  #     @current_journey.end(nil)
  #     @log << @current_journey
  #     @current_journey = nil
  #   else
  #     @current_journey = journey
  #     @current_journey.start(entry_station)
  #   end
  # end



end
