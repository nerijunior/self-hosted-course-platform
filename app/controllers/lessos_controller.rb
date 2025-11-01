class LessosController < ApplicationController
  before_action :set_lesso, only: %i[ show edit update destroy ]

  # GET /lessos or /lessos.json
  def index
    @lessos = Lesso.all
  end

  # GET /lessos/1 or /lessos/1.json
  def show
  end

  # GET /lessos/new
  def new
    @lesso = Lesso.new
  end

  # GET /lessos/1/edit
  def edit
  end

  # POST /lessos or /lessos.json
  def create
    @lesso = Lesso.new(lesso_params)

    respond_to do |format|
      if @lesso.save
        format.html { redirect_to @lesso, notice: "Lesso was successfully created." }
        format.json { render :show, status: :created, location: @lesso }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessos/1 or /lessos/1.json
  def update
    respond_to do |format|
      if @lesso.update(lesso_params)
        format.html { redirect_to @lesso, notice: "Lesso was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @lesso }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessos/1 or /lessos/1.json
  def destroy
    @lesso.destroy!

    respond_to do |format|
      format.html { redirect_to lessos_path, notice: "Lesso was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesso
      @lesso = Lesso.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lesso_params
      params.expect(lesso: [ :course_id, :unit_id, :name, :filename ])
    end
end
