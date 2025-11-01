class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :path, null: false
      t.string :status, null: false, default: 'importing'

      t.timestamps
    end
  end
end
