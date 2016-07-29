class User < ActiveRecord::Base
  has_many :roles
  has_many :projects, through: :roles
  has_many :tasks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  def can_view?(project)
    visible_projects.include?(project)
  end

  def visible_projects
    return Project.all.to_a if admin?
    (projects.to_a + Project.all_public).uniq.sort_by(&:id)
  end

  def avatar_url
    adapter = AvatarAdapter.new(self)
    adapter.image_url
  end
end
