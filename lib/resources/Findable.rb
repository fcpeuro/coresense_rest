module CoresenseRest
  module Findable

    def find id
      RequestRead.new(full_path + '/' + id.to_s, headers, self).select
    end

  end
end