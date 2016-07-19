require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "POST create" do
    it "creates a project" do
      fake_action = instance_double(CreatesProject, create: true)
      expect(CreatesProject).to receive(:new)
      .with(name: "Runway", task_string: "start something:2")
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
end
