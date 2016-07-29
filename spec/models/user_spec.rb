require 'spec_helper'

describe User do
  RSpec:: Matchers.define :be_able_to_see do |*projects|
    match do |user|
      expect(user.visible_projects).to eq(projects)
      projects.all? { |p| expect(user.can_view?(p)).to be_truthy }
      (all_projects - projects).all? { |p| expect(user.can_view?(p)).to be_falsy }
    end
  end

  describe 'visibility' do
    let(:user) { User.create!(email: 'user@example.com', password: 'password') }
    let!(:project_1) { Project.create!(name: 'Project 1') }
    let!(:project_2) { Project.create!(name: 'Project 2') }
    let(:all_projects) { [project_1, project_2] }

    before(:context) do
      Project.delete_all
    end

    it 'alows a user to see their projects' do
      user.projects << project_1
      expect(user).to be_able_to_see(project_1)
    end

    it 'allows an admin to see all projects' do
      user.admin = true
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it 'allows a user to see public projects' do
      user.projects << project_1
      project_2.update(public: true)
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it 'has no dupes in project list' do
      user.projects << project_1
      project_1.update(public: true)
      expect(user).to be_able_to_see(project_1)
    end
  end

  describe 'avatars' do
    let(:user) { User.new(email: 'test@example.com') }
    let(:fake_adapter) { instance_double(AvatarAdapter) }

    it 'can get a twitter avatar URL' do
      allow(fake_adapter).to receive(:image_url).and_return('fake_url')
      allow(AvatarAdapter).to receive(:new).with(user).and_return(fake_adapter)
      user.avatar_url
      expect(fake_adapter).to have_received(:image_url)
      expect(AvatarAdapter).to have_received(:new)
    end
  end
end
