class FakeIntercom
  attr_reader :events

  def initialize
    @events = Event.new([])
  end

  def events_for(user)
    @events.tracked_events_for(user)
  end

  class Event
    def initialize(tracked_events)
      @tracked_events = tracked_events
    end

    def create(options)
      @tracked_events << options
    end

    def tracked_events_for(user)
      self.class.new(
        tracked_events.select do |event|
          event[:email] == user.email
        end
      )
    end

    def named(event_name)
      self.class.new(
        tracked_events.select do |event|
          event[:event_name] == event_name
        end
      )
    end

    def has_metadata?(options)
      tracked_events.any? do |event|
        options.all? do |key, value|
          (event[:metadata])[key] == value
        end
      end
    end

    def empty?
      tracked_events.empty?
    end

    private

      attr_reader :tracked_events
  end
end
