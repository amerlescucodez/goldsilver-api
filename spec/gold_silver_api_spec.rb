require 'minitest/autorun'
require './lib/gold_silver_api'

describe GoldSilver do
  before do
    GoldSilver.configure do |config|
      config.access_token = "goldapi-<access_token>-io"
    end #/block - configure
  end #/block - before

  describe "Interact with GoldApi.io" do
    it "should return the current price for gold" do
      request = GoldSilver::API.fetch("XAU", "USD")
      expect(request[:result]["price"]).must_be_instance_of Float
    end #/it 
  end #/block - describe
end #/block - describe