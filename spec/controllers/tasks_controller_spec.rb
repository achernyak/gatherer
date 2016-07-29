require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { User.create!(email: 'rspec@example.com', password: 'password')}

  before(:example) do
    ActionMailer::Base.deliveries.clear
    sign_in user
  end

  describe "PATCH update" do
    let(:task) { Task.create!(title: "Write section on testing mailers", size: 2) }
    it "does not send an email if a task is not completed" do
      patch :update, id: task.id, task: {size: 3}
      expect(ActionMailer::Base.deliveries.size).to eq(0)
    end

    it "sends email when task is completed" do
      patch :update, id: task.id, task: { size: 3, completed: true }
      task.reload
      expect(task.completed_at).to be_present
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq("A task has been completed")
      expect(email.to).to eq(["monitor@tasks.com"])
      expect(email.body.to_s).to match(/Write section on testing mailers/)
    end
  end

  describe 'POST create' do
    fixtures :all
    let(:project) { Project.create!(name: 'Project Runway') }

    it 'allows a user to createa  task for aproject they belog to' do
      p project
      p user
      user.projects << project
      user.save!
      post :create, task: {project_id: project.id, title: 'just do it', size: 1 }
      expect(project.reload.tasks.first.title).to eq('just do it')
    end

    it 'does not allow a user to create a task for a project without access' do
      post :create, task: {project_id: project.id, title: 'just do it', size: 1 }
      expect(project.reload.tasks.size).to eq(0)
    end
  end
end
