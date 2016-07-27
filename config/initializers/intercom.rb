IntercomRuby = Intercom::Client.new(app_id: ENV["INTERCOM_APP_ID"] || "", api_key: ENV["INTERCOM_API_KEY"] || "")

IntercomRails.config do |config|
  config.app_id = ENV["INTERCOM_APP_ID"]
  config.api_secret = ENV["INTERCOM_SECRET_KEY"]

  config.enabled_environments = []
  config.enabled_environments += [Rails.env] if ENV["INTERCOM_APP_ID"]

  config.user.model = Proc.new { User }
  config.user.custom_data = {
    :role => Proc.new { |current_user| current_user.roles.map(&:name).first }
  }
end
