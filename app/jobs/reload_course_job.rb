class ReloadCourseJob < ApplicationJob
  queue_as :default

  def perform(course)
    Rails.logger.info("Reading course path [#{course.path}]")
    units_dirs = Dir.glob("#{course.path}/*").select { |e| File.directory?(e) }

    if units_dirs.empty?
      Rails.logger.info("No directory found for course #{course.name} in #{course.path}")
      return
    end

    ActiveRecord::Base.transaction do
      units_dirs.each do |dir|
        unit = Unit.find_or_create_by!(course: course, name: File.basename(dir), path: dir)

        movie_files = Dir.glob("#{dir}/*").select { |e| File.extname(e) == ".mp4" }

        if movie_files.empty?
          Rails.logger.info("No movie files in #{dir}")
        end

        movie_files.each do |file|
          Rails.logger.info("Creating lesson from file #{file}")
          unit.lessons.find_or_create_by!(name: File.basename(file, ".*"), filename: file)
        end
      end

      course.update!(status: :imported)
    rescue => e
      Rails.logger.error(e)
      course.update!(status: :failed)
    end
  end
end
