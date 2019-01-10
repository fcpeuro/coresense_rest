module CoresenseRest
  module Updatable

    def update body
      RequestWrite.update(full_path, @headers, body)
    end

  end
end


