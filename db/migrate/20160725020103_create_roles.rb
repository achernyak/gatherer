class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.string :role_name

      t.timestamps
    end
  end
end
