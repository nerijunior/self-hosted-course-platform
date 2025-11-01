class ReloadCoursesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    raise "COURSES_PATH not set" if ENV["COURSES_PATH"].empty?

    path = ENV["COURSES_PATH"]
    dirs = Dir.glob("#{path}/*").select { |e| File.directory?(e) }

    if dirs.empty?
      Rails.logger.info("No course found. Skipping")
      return
    end

    ActiveRecord::Base.transaction do
      dirs.each do |dir|
        course = Course.find_or_create_by!(name: File.basename(dir), path: dir)

        if course.persisted?
          course.update!(status: :refreshing)
        end

        Rails.logger.info("Scheduling job to load course from #{dir}")
        ReloadCourseJob.perform_later(course)
      end
    end
  end
end
