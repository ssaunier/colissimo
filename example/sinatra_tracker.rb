# From the gem root repository, run:
# $ ruby example/sinatra_tracker.rb

require 'sinatra'
$: << "lib"
require "colissimo"

get '/' do
  tracking_code = params[:tracking_code]
  output = "<form method='get'><input name='tracking_code' placeholder='Colissimo Tracking Code' value='#{tracking_code}' /></form>"

  if tracking_code
    tracking_rows = Colissimo::Tracker.new(tracking_code).tracking_rows

    output += "<table>"
    tracking_rows.each do |row|
      output += "  <tr>"
      output += "    <td><img src='#{row.date_base64_png}' /></td>"
      output += "    <td><img src='#{row.label_base64_png}' /></td>"
      output += "    <td><img src='#{row.localization_base64_png}' /></td>"
      output += "  </tr>"
    end
    output += "</table>"
  end

  output
end