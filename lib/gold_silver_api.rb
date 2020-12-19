# frozen_string_literal: true
require 'logging'

module GoldSilver
end

begin
  require 'rails'
rescue LoadError
  # do nothing
end #/begin-rescue

require_relative 'gold_silver_api/config'
require_relative 'gold_silver_api/logger'
require_relative 'gold_silver_api/api'

if defined? ::Rails::Railtie
  require_relative 'gold_silver_api/railtie'
end #/if