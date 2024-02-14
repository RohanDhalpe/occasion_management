class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :update, :destroy]

  # GET /venues
  def index
    @venues = Venue.all
    if params[:venue_type].present?
      @venues = @venues.where(venue_type: params[:venue_type] )
    end
    render json: @venues
  end

  # GET /venues/1
  def show
    render json: @venue
  end

  # POST /venues
  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      render json: @venue, status: :created
    else
      render json: { error: @venue.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /venues/1
  def update
    if @venue.update(venue_params)
      render json: @venue
    else
      render json: { error: @venue.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /venues/1
  def destroy
    @venue = Venue.find_by(id: params[:id])
    if @venue
      @venue.destroy
      render json: { message: 'venue deleted successfully.' }
    else
      render json: { error: 'Venue not found.' }, status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_venue
    @venue = Venue.find(params[:id])
  end

  def venue_params
    params.require(:venue).permit(:name, :venue_type, :start_time, :end_time)
  end
end
