class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :update, :destroy]

  # GET /appointments
  # GET /appointments.json
  
  def index
    @appointments = Appointment.where(:user => current_user)
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @types = ["Free","Blocked","Potentially Blocked","Away"]
    @current_user = current_user
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
 

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user.id
    #check own conflicts
    @appointments = Appointment.where(:user => current_user)
    for apt in @appointments
      dA = DateTime.strptime(apt.startdate.to_s[0..14], '%Y-%m-%d %H:%M')
      dB = DateTime.strptime(apt.enddate.to_s[0..14], '%Y-%m-%d %H:%M')
      dC = DateTime.strptime(@appointment.start_at_date[0..14], '%Y-%m-%d %H:%M')
      dD = DateTime.strptime(@appointment.end_at_date[0..14], '%Y-%m-%d %H:%M')
      if ((dC < dB) or (dD < dB)) and ((dC > dA) or (dD > dA)) and
          (apt.typeapp != 'Free') and (@appointment.typeapp != 'Free') 
        flash[:error] = 'There\'s a conflict with one of your appointments [ ' + apt.title + ' ]'
        redirect_to :action => 'new'
        return  
      end
    end
    if @appointment.userschedule != ''
      flash[:info] = @appointment.userschedule
      #check other user conflicts
      @aptuser = Appointment.where(:user => @appointment.userschedule)
      for apt in @aptuser
        dA = DateTime.strptime(apt.startdate.to_s[0..14], '%Y-%m-%d %H:%M')
        dB = DateTime.strptime(apt.enddate.to_s[0..14], '%Y-%m-%d %H:%M')
        dC = DateTime.strptime(@appointment.start_at_date[0..15], '%Y-%m-%d %H:%M')
        dD = DateTime.strptime(@appointment.end_at_date[0..15], '%Y-%m-%d %H:%M')
        if ((dC < dB) or (dD < dB)) and ((dC > dA) or (dD > dA)) and
            (apt.typeapp != 'Free') and (@appointment.typeapp != 'Free') 
          flash[:error] = 'There\'s a conflict with an appointments from ' + User.where(:id => @appointment.userschedule).first.username + ': [ ' + apt.title + ' ]'
          redirect_to :action => 'new'
          return  
        end
      end
    end
    
    if not @appointment.check_dates
      flash[:error] = 'End date must be after start date in the time'
      redirect_to :action => 'new'
      return
    end
    
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
        format.json { render :show, status: :created, location: @appointment }
      else
        @types = ["Free","Blocked","Potentially Blocked","Away"]
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, notice: 'Appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:startdate, :enddate, :title, :notes, :typeapp, :visibility, :start_at_date, :end_at_date, :userschedule)
    end
end
