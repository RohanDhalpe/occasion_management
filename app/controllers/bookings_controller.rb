class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]

  # GET /bookings
  def index
    @bookings = Booking.all

    if params[:venue_id]
      @bookings = @bookings.where(venue_id: params[:venue_id])
    elsif params[:user_id]
      @bookings = @bookings.where(user_id: params[:user_id])
    elsif params[:booking_date]
      @bookings = @bookings.where(booking_date: params[:booking_date])
    elsif params[:start_time] && params[:end_time]
      @bookings = @bookings.where('start_time >= ? AND end_time <= ?',params[:start_time], params[:end_time])
    elsif params[:status]
      @bookings = @bookings.where(status: params[:status])
    end

    render json: @bookings
  end


  # GET /bookings/1
  def show
    render json: @booking
  end

  # POST /bookings
  def create
    p booking_params
    @booking = Booking.new(booking_params)

    if @booking.save
      render json: @booking, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking = Booking.find_by(id: params[:id])

    if @booking.nil?
      render json: { error: 'Booking not found' }, status: :not_found
    else
      @booking.destroy
      render json: { message: 'Booking with ID ' + params[:id] + ' was successfully destroyed' }
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :venue_id, :booking_date, :start_time, :end_time, :status)
  end
end
