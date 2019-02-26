#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'openssl'
require 'csv'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def get_caleg
  file = "dapil.csv"
  csv = CSV.foreach(file) do |row|
    puts row[2]
    scrape row[2]
  end
end

def scrape url
  id = url.split("/").last
  filename = id.to_s + ".csv"
  html = open(url)

  doc = Nokogiri::HTML(html)

  puts "processing #{url}"

  CSV.open(filename, 'wb') do |csv|
    record = []
    doc.search("table.MsoNormalTable/tbody/tr/td/p.MsoNormal/font", "table.MsoNormalTable/tbody/tr/td/p.MsoNormal/span").each_with_index do |data, i|
      record << data.text.gsub('"', '') if i % 3 == 0 || i % 3 == 1
      if i % 3 == 2
        csv << record
        record = []
      end
    end
  end
end

get_caleg
puts "success ..."