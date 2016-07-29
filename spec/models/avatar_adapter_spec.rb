require 'rails_helper'

describe AvatarAdapter do
  it 'accurately receives image url', :vcr do
    user = double(twitter_handle: 'noelrap')
    adapter = AvatarAdapter.new(user)
    url = 'http://pbs.twimg.com/profile_images/40008602/head_shot_bigger.jpg'
    expect(adapter.image_url).to eq(url)
  end
end
