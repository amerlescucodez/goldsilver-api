module GoldSilver
  class << self
    def configure
      yield config
    end #/def

    def config
      @_config ||= Config.new
    end #/def
  end #/class

  class Config
    attr_accessor :access_token
    attr_accessor :use_ssl

    def initialize
      @access_token = nil
      @use_ssl = true
    end #/def
  end #/class
end #/module