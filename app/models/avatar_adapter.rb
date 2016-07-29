class AvatarAdapter
  attr_accessor :user, :client

  def initialize(user)
    @user = user
  end

  def client
    @client ||= Twitter::REST::Client.new(
      consumer_key: Rails.application.secrets.twitter_api,
      consumer_secret: Rails.application.secrets.twitter_secret
    )
  end

  def image_url
    client.user(user.twitter_handle).profile_image_uri(:bigger).to_s
  end
end
