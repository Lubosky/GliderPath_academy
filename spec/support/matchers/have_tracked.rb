RSpec::Matchers.define :have_tracked do |event_name|
  match do |analytics_backend|
    @event_name = event_name
    @analytics_backend = analytics_backend

    events =
      if @user.present?
        analytics_backend.events_for(@user)
      else
        analytics_backend.events
      end

    events.
      named(@event_name).
      has_metadata?(@metadata || {})
  end

  chain(:for_user) { |user| @user = user }
  chain(:with_metadata) { |metadata| @metadata = metadata }
end
