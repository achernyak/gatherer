require "rails_helper"

RSpec.describe "projects/index" do
  describe "projects/index" do
    let(:completed_task) { Task.create!(completed_at: 1.day.ago, size: 1) }
    let(:on_schedule) { Project.create!(due_date: 1.year.from_now,
      name: "On Schedule", tasks: [completed_task]) }
    let(:incomplete_task) { Task.create!(size: 1) }
    let(:behind_schedule) { Project.create!(due_date: 1.day.from_now,
      name: "Behind Schedule", tasks: [incomplete_task]) }

    it "renders teh index page with correct dom elements" do
      @projects = [on_schedule, behind_schedule]
      render
      expect(rendered).to have_selector(
        "#project_#{on_schedule.id} .on_schedule")
      expect(rendered).to have_selector(
        "#project_#{behind_schedule.id} .behind_schedule")
    end
  end
end
