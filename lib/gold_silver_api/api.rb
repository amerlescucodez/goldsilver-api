require 'net/http'
require 'json'
require_relative 'consts'

module GoldSilver
  class API
    class << self
      def fetch metal, currency, date=nil
        raise ArgumentError, "missing metal argument" if metal.nil?
        metal = "X#{metal&.upcase}" if metal.length == 2
        raise ArgumentError, "invalid metal argument" unless GSAPI_METALS.include?(metal)
        raise ArgumentError, "missing currency argument" if currency.nil?
        raise ArgumentError, "invalid currency argument" unless GSAPI_CURRENCIES.include?(currency)
        
        GoldSilver.logger.debug "Attempting to fetch #{metal} in #{currency}."
        
        uri = nil
        if date
          uri = URI.parse("https://www.goldapi.io/api/#{metal&.upcase}/#{currency&.upcase}/#{date&.upcase}")
        else
          uri = URI.parse("https://www.goldapi.io/api/#{metal&.upcase}/#{currency&.upcase}")
        end #/if-else
        
        response = nil
        result = nil
        Net::HTTP.start(uri.host, uri.port, use_ssl: GoldSilver.config.use_ssl) do |http|
          req = Net::HTTP::Get.new(uri)
          req['Content-Type'] = 'application/json'
          req['x-access-token'] = GoldSilver.config.access_token
          response = http.request(req)
          result = response&.body
        end #/block

        {
          success: response.instance_of?(Net::HTTPOK),
          response: response,
          result: JSON.parse(result)
        }
      # rescue
      #   {
      #     success: false,
      #     response: nil
      #   }
      end #/def
    end #/class
  end #/class
end #/class