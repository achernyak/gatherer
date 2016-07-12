class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project, index: true
      t.string :title
      t.integer :size
      t.datetime :completed_at

      t.timestamps
    end
  end
end
