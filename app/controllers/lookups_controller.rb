class LookupsController < ApplicationController
  before_action :set_lookup, only: %i[ show ]

  # GET /lookups or /lookups.json
  def index
    # This should be paginated
    @lookups = Lookup.order(created_at: :desc)
  end

  # GET /lookups/1 or /lookups/1.json
  def show
  end

  # GET /lookups/new
  def new
    @lookup = Lookup.new
  end

  # POST /lookups or /lookups.json
  def create
    @lookup = LookupService.lookup_by_zipcode(zipcode: lookup_params[:zipcode])

    respond_to do |format|
      if @lookup.save
        format.html { redirect_to lookup_url(@lookup), notice: "Lookup was successfully created." }
        format.json { render :show, status: :created, location: @lookup }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lookup
    @lookup = Lookup.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lookup_params
    params.require(:lookup).permit(:zipcode)
  end
end
