# -*- encoding : utf-8 -*-
require "selenium-webdriver"
require "yaml"
require "./korning-lib.rb"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://fp.vv.se/bookingpublic/logon/Privatistbokning.aspx"

credentials = YAML.load_file 'user.yml'

credentials.each { |key, value|
  element = driver.find_element(:id, "ctl00_ContentPlaceHolder1_txt#{key}")
  element.send_keys value
}

driver.find_element(:class, "EAbutton").click # Skicka credentials
driver.find_element(:id, "ctl00_ContentMain_ButtonBook").click #
driver.find_element(:id, "ctl00_ContentMain_ButtonNext").click # Typ B körkort
driver.find_element(:id, "ctl00_ContentMain_ButtonNext").click # Körprov B

select = driver.find_element(:id, "ctl00_ContentMain_ddlCounties")
all_options = select.find_elements(:tag_name, "option")
all_options.each do |option|
  value = option.attribute("value")
  if value == "1" # Select 1, which is Stockholm
    option.click
    break
  end
end
driver.find_element(:id, "ctl00_ContentMain_RadioButtonCounty").click # Länets tio snabbaste
driver.find_element(:id, "ctl00_ContentMain_btnShow").click # Click "Visa"

i = 0
while true
  puts "Attempt #{i+=1}:"
  labelss = driver.find_elements(:tag_name, "label").each_slice(6)
  raw_lines = labelss.map do |labels|
    labels.map(&:text).join(" ")
  end
  puts raw_lines.join("\n")
  Goer::go(raw_lines)
  sleep(30)
  driver.find_element(:id, "ctl00_ContentMain_OccasionList1_btnUpdateOccasions").click
end

