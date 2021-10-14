# frozen_string_literal: true

module CoresenseRest
  module Updatable
    def update(body)
      if body.is_a? Hash
        body[:id] = self.id
        RequestWrite.new(full_path, headers, self, body).update
      else
        raise ArgumentError, "Expected Hash, got #{body.class.name}"
      end
    end

    def save
      RequestWrite.new(full_path, headers, self, 'json').update
    end
  end
end
