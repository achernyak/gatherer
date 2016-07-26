require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { User.create!(email: 'rspec@example.com', password: 'password') }
  
  before do
    sign_in(user)
  end

  describe 'GET index' do
    it 'displays all projects correctly' do
      user = User.new
      project = Project.new(name: 'Project Greenlight')
      expect(controller).to receive(:current_user).and_return(user)
      expect(user).to receive(:visible_projects).and_return([project])
      get :index
      assert_equal assigns[:projects].map(&:__getobj__), [project]
    end
  end

  describe "POST create" do
    it "creates a project" do
      fake_action = instance_double(CreatesProject, create: true)
      expect(CreatesProject).to receive(:new)
        .with(name: "Runway", task_string: "start something:2", users: [user])
        .and_return(fake_action)

      post :create, project: { name: "Runway", tasks: "start something:2" }
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action)).not_to be_nil
    end

    it "goes back to the form on failure" do
      action_stub = double(create: false, project: Project.new)
      expect(CreatesProject).to receive(:new).and_return(action_stub)
      post :create, project: { name: 'Project Runway' }
      expect(response).to render_template(:new)
    end
  end

  describe 'GET show' do
    let(:project) { Project.create(name: 'Project Runway') }

    it 'allows a user who is part of the project to see the project' do
      controller.current_user.stub(can_view?: true)
      get :show, id: project.id
      expect(response).to render_template(:show)
    end

    it 'does not allow a user who is not part of the project to see the project' do
      controller.current_user.stub(can_view?: false)
      get :show, id: project.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
