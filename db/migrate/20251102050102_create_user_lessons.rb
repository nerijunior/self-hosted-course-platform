class CreateUserLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :user_lessons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.boolean :watched, default: false, null: false
      t.datetime :watched_at

      t.timestamps
    end

    add_index :user_lessons, [ :user_id, :lesson_id ], unique: true
  end
end
