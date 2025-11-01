class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy video ]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /lessons/1/video
  def video
    video_path = @lesson.filename

    Rails.logger.info("Serving video file: #{video_path}")

    # Check if file exists
    unless File.exist?(video_path)
      Rails.logger.error("Video file not found: #{video_path}")
      head :not_found
      return
    end

    # Get file info
    file_size = File.size(video_path)
    content_type = "video/mp4"

    # Always set basic headers
    response.headers["Accept-Ranges"] = "bytes"
    response.headers["Content-Type"] = content_type

    # Handle range requests for video seeking
    if request.headers["HTTP_RANGE"]
      Rails.logger.info("Handling range request: #{request.headers['HTTP_RANGE']}")

      range = request.headers["HTTP_RANGE"]
      range_match = range.match(/bytes=(\d+)-(\d*)/)

      if range_match
        start_byte = range_match[1].to_i
        end_byte = range_match[2].empty? ? file_size - 1 : range_match[2].to_i

        # Ensure end_byte doesn't exceed file size
        end_byte = [ end_byte, file_size - 1 ].min
        content_length = end_byte - start_byte + 1

        response.headers["Content-Range"] = "bytes #{start_byte}-#{end_byte}/#{file_size}"
        response.headers["Content-Length"] = content_length.to_s
        response.status = 206 # Partial Content

        # Stream the file chunk
        File.open(video_path, "rb") do |file|
          file.seek(start_byte)
          send_data file.read(content_length),
                   type: content_type,
                   disposition: "inline",
                   status: :partial_content
        end
      else
        Rails.logger.error("Invalid range request format")
        head :bad_request
      end
    else
      # Initial request - serve first chunk or entire file for small files
      Rails.logger.info("Serving initial video request")

      # For video files, browsers typically make an initial range request
      # If no range is specified, we can either serve the whole file or a chunk
      if file_size > 1.megabyte
        # For large files, serve first chunk to start playback quickly
        chunk_size = 1.megabyte
        response.headers["Content-Range"] = "bytes 0-#{chunk_size - 1}/#{file_size}"
        response.headers["Content-Length"] = chunk_size.to_s
        response.status = 206

        File.open(video_path, "rb") do |file|
          send_data file.read(chunk_size),
                   type: content_type,
                   disposition: "inline",
                   status: :partial_content
        end
      else
        # For smaller files, serve the entire file
        response.headers["Content-Length"] = file_size.to_s
        send_file video_path, type: content_type, disposition: "inline"
      end
    end
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: "Lesson was successfully created." }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to @lesson, notice: "Lesson was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy!

    respond_to do |format|
      format.html { redirect_to lessons_path, notice: "Lesson was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.expect(lesson: [ :course_id, :unit_id, :name, :filename ])
    end
end
