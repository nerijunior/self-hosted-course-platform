class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :course, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.string :name
      t.string :filename

      t.timestamps
    end
  end
end
