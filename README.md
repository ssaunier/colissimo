[![Build Status](https://travis-ci.org/ssaunier/colissimo.png)](https://travis-ci.org/ssaunier/colissimo)

# Colissimo

This gem allows you to retrieve tracking information from French Colissimo
parcel delivery company. Unfortunatelly you won't get this information in
a text format, but in an image format. That's fine for display though.

## Usage

Add the `colissimo` gem to your `Gemfile`, run the `bundle` command.

```ruby
require "colissimo"

tracking_code = "6C07437595437"

rows = Colissimo::Tracker.new(tracking_code).tracking_rows

output = "<table>"
rows.each do |row|
  output += "  <tr>"
  output += "    <td><img src='#{row.date_base64_png}' /></td>"
  output += "    <td><img src='#{row.label_base64_png}' /></td>"
  output += "    <td><img src='#{row.localization_base64_png}' /></td>"
  output += "  </tr>"
end
output += "</table>"

```

If you are interested in just the latest status, you can save some bandwidth
witht this option:


```ruby
Colissimo::Tracker.new(tracking_code).tracking_rows(:latest_only => true)

```