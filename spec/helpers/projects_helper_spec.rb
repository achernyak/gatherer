require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ProjectsHelper. For example:
#
# describe ProjectsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ProjectsHelper, type: :helper do
  let(:project) { Project.new(name: "Project Runway" ) }

  it "augments with status info" do
    allow(project).to receive(:on_schedule?).and_return(true)
    actual = helper.name_with_status(project)
    expect(actual).to have_selector("span.on_schedule", text: "Project Runway")
  end

  it "augments project name with status info when behind schedule" do
    allow(project).to receive(:on_schedule?).and_return(false)
    actual = helper.name_with_status(project)
    expect(actual).to have_selector("span.behind_schedule", text: "Project Runway")
  end
end
