json.extract! course, :id, :name, :path, :created_at, :updated_at
json.url course_url(course, format: :json)
