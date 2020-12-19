# GoldAPI Gem

If you wish to use the price of Gold and Silver on your Rails application and you wish to use GoldApi.io as your data-source, then use this gem.

## Installation

Add this to your `Gemfile`:

```ruby
gem 'gold_silver_api', '~> 1.0'
```

Or install it locally to your system: 

```bash
gem install gold_silver_api
```

## Configuration

If you're using Rails, then add a new file `config/initializers/gold_silver_api.rb` with: 

```ruby
require 'gold_silver_api'
GoldSilver.configure do |config|
  config.access_token = "goldapi-<access_token>-io"
end
```

> Replace `goldapi-<access_token>-io` with your access token, which can be found **[On GoldApi.io](https://www.goldapi.io/dashboard)**.

## Usage

Make a request: 

```ruby
class BullionController < ActionController::Base

  def index
    @gold_price = GoldSilver::API.fetch("XAU", "USD")
    @gold_on_november_3rd_2020 = GoldSilver::API.fetch("XAU", "USD", "20201103")
  end #/def

end #/class
```

Here is a table of argument potential values: 

| `metal` | `currency` | `date` |
|:--------|:-----------|:-------|
| `XAU` - Gold | `AED` - U.A.E. Dirham | `YYYYMMDD` |
| `XAG` - Silver | `AUD` - Austrialian Dollar | |
| `XPT` - Platinum | `BTC` - Bitcoin | |
| `XPD` - Palladium | `CAD` - Canadian Dollar | |
| | `CHF` - Swiss Franc | |
| | `CNY` - Chinese/Yuan renminbi | |
| | `CZK` - Czech Krona | |
| | `EUR` - European Euro | |
| | `GBP` - British Pound | |
| | `INR` - Indian Rupee | |
| | `JPY` - Japanese Yen | |
| | `KWD` - Kuwaiti Dinar | |
| | `MYR` - Malaysian Ringgit | |
| | `PLN` - Polish Zloty | |
| | `RUB` - Russian Ruble | |
| | `SGD` - Singapore Dollar | |
| | `THB` - Thai Baht | |
| | `USD` - United States Dollar | |
| | `XAG` - Gold/Silver Ratio | |
| | `ZAR` - South African Rand | |

> Invalid metals and currencies will be rejected automatically by raising an `ArgumentError`. **NOTE**: `date` is not validated.

## Advanced Usage

You might want to cache your value with Redis (update the connection request to your system)...

```ruby
class BullionController < ActionController::Base

  def index
    
    @gold_price = get_or_fetch_price("XAU", "USD") # redis.get("gold_silver_api-xau-usd")
  end #/def

  protected

  def get_or_fetch_price metal, currency
    # cert = File.open(ENV['REDIS_CERT_FILE'], 'r').read
    # key = File.open(ENV['REDIS_KEY_FILE'], 'r').read
    redis = Redis.new(
      url: "#{ENV['REDIS_DSN']}/5",
      network_timeout: 9#, 
      # ssl: true,
      # ssl_params: {
      #   :ca_file     => ENV['REDIS_CA_FILE'],
      #   :cert        => OpenSSL::X509::Certificate.new(cert),
      #   :key         => OpenSSL::PKey::RSA.new(key),
      #   :verify_mode => OpenSSL::SSL::VERIFY_NONE
      # }
    )

    result = redis.get("gold_silver_api-#{metal}-#{currency}")
    if result.nil?
      call = GoldSilver::API.fetch(metal, currency)
      unless call.nil?
        result = call[:result]
        unless result.nil?
          redis.set("gold_silver_api-#{metal}-#{currency}", result[:price])
          return result[:price]
        else
          return nil
        end #/unless-else
      else
        return nil
      end #/unless-else
    else
      return result
    end #/if-else
  end #/def
end #/class
```

## Response from API

Request `GoldSilver::API.fetch("XAU", "USD")` to get the price of Gold (Au) in US Dollars (USD) will return with the following result

```json
{
  "timestamp":1608354836,
  "metal":"XAU",
  "currency":"USD",
  "exchange":"FOREXCOM",
  "symbol":"FOREXCOM:XAUUSD",
  "prev_close_price":1885.56,
  "open_price":1885.56,
  "low_price":1877.53,
  "high_price":1889.71,
  "open_time":1608242400,
  "price":1881.24,
  "ch":-4.32,
  "chp":-0.23,
  "ask":1882.28,
  "bid":1880.28
}
```

To access the price: 

```ruby
gold_price_usd = nil
call = GoldSilver::API.fetch("XAU", "USD")
if call
  result = call[:result]
  if result
    gold_price_usd = result["price"]
  end #/if
end #/if
if gold_price_usd.nil?
  # error we were unable to get the price
end #/if
# use gold_price_usd as much as you wish
```

## Testing

```bash
ruby spec/gold_silver_api_spec.rb
```

Expected output should be: 

```
Run options: --seed 21855

# Running:

.

Finished in 0.171850s, 5.8190 runs/s, 5.8190 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

## Errors

If you are missing the `access_token`, then if you attempt to run the tests, you might get the following kind of output: 

```
Run options: --seed 17828

# Running:

F

Failure:
GoldSilver::Interact with GoldApi.io#test_0001_should return the current price for gold [spec/gold_silver_api_spec.rb:14]:
Expected nil to be an instance of Float, not NilClass.


rails test spec/gold_silver_api_spec.rb:12



Finished in 0.151836s, 6.5861 runs/s, 6.5861 assertions/s.
1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```

## Credit

This gem was created by [Andrei Merlescu](https://github.com/sponsors/patriotphoenix). 

## License

[MIT License](LICENSE)
