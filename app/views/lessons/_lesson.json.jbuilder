json.extract! lesson, :id, :course_id, :unit_id, :name, :filename, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)
