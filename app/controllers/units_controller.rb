class UnitsController < ApplicationController
  before_action :set_course
  before_action :set_unit, only: %i[ show edit update destroy ]

  # GET /units or /units.json
  def index
    @units = Unit.all
  end

  # GET /units/1 or /units/1.json
  def show
    @lesson = @unit.lessons.order(:created_at).first
    if @lesson.present?
      redirect_to [ @course, @unit, @lesson ]
    else
      # If no lessons exist for this unit, return 404
      head :not_found
    end
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units or /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to [ @course, @unit ], notice: "Unit was successfully created." }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1 or /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to [ @course, @unit ], notice: "Unit was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1 or /units/1.json
  def destroy
    @unit.destroy!

    respond_to do |format|
      format.html { redirect_to course_units_path(@course), notice: "Unit was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_course
      @course = Course.find(params.expect(:course_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def unit_params
      params.expect(unit: [ :course_id, :name, :path ])
    end
end
