class ForumSessionsController < ApplicationController
  before_action :authenticate_user!

  def new
    authorize :forum_session
    sso = DiscourseSignOn.parse(
      request.query_string,
      ENV['DISCOURSE_SSO_SECRET']
    )
    populate_sso_for_current_user(sso)
    track_forum_access
    redirect_to sso.to_url(Forum.sso_url)
  end

  private

    def populate_sso_for_current_user(sso)
      sso.email = current_user.email
      sso.name = current_user.name
      sso.username = current_user.email
      sso.external_id = current_user.id
      sso.sso_secret = ENV['DISCOURSE_SSO_SECRET']
    end

    def track_forum_access
      analytics.track_forum_accessed
    end

end
