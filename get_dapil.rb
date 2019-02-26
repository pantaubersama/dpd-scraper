#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'openssl'
require 'csv'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def get_dapil
  url = "https://kpu.go.id/index.php/pages/detail/2018/951"
  html = open(url)

  doc = Nokogiri::HTML(html)

  CSV.open('dapil.csv', 'wb') do |csv|
    doc.search("div.kotak_box_noborder/div/div/font/div/a").each do |data|
      csv << [data.values.first.split("/").last, data.text, data.values.first]
    end
  end
end

get_dapil
puts "success ...."