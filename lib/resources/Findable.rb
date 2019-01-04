module CoresenseRest
  module Findable

    def find id
      Request.new(full_path + '/' + id.to_s, @headers).select
    end

  end
end