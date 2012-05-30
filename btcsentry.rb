#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"

require "net/http"
require "json"
require "mail"


VERSION = "0.1.0"
SLEEP_INTERVAL = 15 * 60


class BTCSentry

  attr_accessor :last_fetched
  attr_accessor :prices
  attr_accessor :market

  def initialize
  end

  def fetch_api_data
    @last_fetched = Time.now.getutc
    @prices = self.get_json "http://bitcoincharts.com/t/weighted_prices.json"
    @markets = self.get_json "http://bitcoincharts.com/t/markets.json"
  end

  protected
  def get_json url
    JSON.parse Net::HTTP.get URI(url)
  end

end