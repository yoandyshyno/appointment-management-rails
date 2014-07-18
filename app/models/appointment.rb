class Appointment < ActiveRecord::Base

  # add the accessors for the two fields
  attr_accessor :start_at_date, :end_at_date, :userschedule
 
  # add some callbacks
  after_initialize :get_datetimes # convert db format to accessors
  before_validation :set_datetimes # convert accessors back to db format
  
  def get_datetimes
    #self.published_at ||= Time.now  # if the published_at time is not set, set it to now
    self.startdate ||= Time.now
    self.enddate ||= Time.now

    self.start_at_date ||= self.startdate.to_formatted_s(:db)
    self.end_at_date ||= self.enddate.to_formatted_s(:db) 
  end

  def set_datetimes
    self.startdate = "#{self.start_at_date}" # convert the two fields back to db
    self.enddate = "#{self.end_at_date} " 
  end

  def check_dates
    return DateTime.strptime(self.end_at_date[0..15], '%Y-%m-%d %H:%M') > DateTime.strptime(self.start_at_date[0..15], '%Y-%m-%d %H:%M')
  end
end
