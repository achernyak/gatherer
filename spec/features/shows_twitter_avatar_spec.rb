require 'rails_helper'

include Warden::Test::Helpers

describe 'task display' do
  fixtures :all

  before(:example) do
    projects(:bluebook).roles.create(user: users(:user))
    users(:user).update_attributes(twitter_handle: 'noelrap')
    tasks(:one).update_attributes(user_id: users(:user).id,
      completed_at: 1.hour.ago)
    login_as users(:user)
  end

  it 'shows a gravatar', :vcr do
    visit project_path(projects(:bluebook))
    url = 'http://pbs.twimg.com/profile_images/40008602/head_shot_bigger.jpg'
    within('#task_1') do
      expect(page).to have_selector('.completed', text: users(:user).email)
      expect(page).to have_selector("img[src='#{url}']")
    end
  end
end
