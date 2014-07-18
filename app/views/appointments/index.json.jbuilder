json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :startdate, :enddate, :title, :notes, :typeapp, :visibility
  json.url appointment_url(appointment, format: :json)
end
