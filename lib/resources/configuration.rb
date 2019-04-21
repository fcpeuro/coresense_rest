module CoresenseRest
  class Configuration
    attr_accessor :host, :user_id, :key

    def initialize
      @host = nil
      @user_id = nil
      @key = nil
    end

  end
end