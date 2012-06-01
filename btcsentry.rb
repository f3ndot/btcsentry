#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"

require "net/http"
require "json"
require "mail"
require "colorize"


VERSION = "0.1.0"
SLEEP_INTERVAL = 15 * 60
FROM_EMAIL = "btcsentry@justinbull.ca"
TO_EMAIL = "me@justinbull.ca"

class BTCSentry

  attr_accessor :last_fetched
  attr_accessor :prices
  attr_accessor :market

  def initialize
  end

  def fetch_api_data
    unless last_fetched.nil?
      if (Time.now.getutc - last_fetched) < SLEEP_INTERVAL
        t = Time.now.getutc - last_fetched
        puts "Warning! It's been #{t.ago} since the last API fetch. Serving old data.".yellow
        return false
      end
    end
    puts "Fetching new API data...".green
    @last_fetched = Time.now.getutc
    @prices = self.get_json "http://bitcoincharts.com/t/weighted_prices.json"
    @markets = self.get_json "http://bitcoincharts.com/t/markets.json"
    return true
  end

  def notify(severity, subject = nil)
    mail = Mail.new do
      from FROM_EMAIL
      to TO_EMAIL
      if subject.nil?
        subject "BTCSentry [${severity.upcase}]: Notification"
      else
        subject "BTCSentry [${severity.upcase}]: #{subject}"
      end
      body ""
    end
    mail.deliver!
  end

  protected
  def get_json url
    JSON.parse Net::HTTP.get URI(url)
  end

end

