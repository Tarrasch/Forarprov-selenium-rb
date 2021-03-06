# -*- encoding : utf-8 -*-
require "rubygems" # For those using old style installations of ruby
require "selenium-webdriver"
require "yaml"
require "./korning-lib.rb"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://fp.vv.se/bookingpublic/logon/Privatistbokning.aspx"

credentials = YAML.load_file 'user.yml'

credentials.each { |key, value|
  element = driver.find_element(id: "ctl00_ContentPlaceHolder1_txt#{key}")
  element.send_keys value
}

driver.find_element(class: "EAbutton").click # Skicka credentials

omboka_element = driver.find_elements(id: "ctl00_ContentMain_ButtonRescheduleBooking").first

if omboka_element
  id = "ctl00_ContentMain_RepeaterCurrentBookings_ctl01_RadioButtonBooking"
  driver.find_element(id: id).click # Assume there is only one option and you want to rebook it
  omboka_element.click
else
  # The user probably doesn't have booked yet, so lets click buttons for booking
  driver.find_element(id: "ctl00_ContentMain_ButtonBook").click #
  driver.find_element(id: "ctl00_ContentMain_ButtonNext").click # Typ B körkort
  driver.find_element(id: "ctl00_ContentMain_ButtonNext").click # Körprov B

  select = driver.find_element(id: "ctl00_ContentMain_ddlCounties")
  all_options = select.find_elements(tag_name: "option")
  all_options.each do |option|
    value = option.attribute("value")
    if value == "1" # Select 1, which is Stockholm
      option.click
      break
    end
  end
  driver.find_element(id: "ctl00_ContentMain_RadioButtonCounty").click # Länets tio snabbaste
  driver.find_element(id: "ctl00_ContentMain_btnShow").click # Click "Visa"

end

i = 0
while true
  puts "Attempt #{i+=1}:"
  labelss = driver.find_elements(tag_name: "label")[(omboka_element ? 5 : 0)..-1].each_slice(6)
  raw_lines = labelss.map do |labels|
    labels.map(&:text).join(" ")
  end
  puts raw_lines.join("\n")
  Goer::go(raw_lines)
  sleep(30)
  driver.find_element(id: "ctl00_ContentMain_OccasionList1_btnUpdateOccasions").click
end

