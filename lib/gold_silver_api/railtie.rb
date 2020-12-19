# frozen_string_literal: true

module GoldSilver
  class Railtie < ::Rails::Railtie #:nodoc:
    # Doesn't actually do anything. Just keeping this hook point, mainly for compatibility
    initializer 'gold_silver' do
    end
  end
end