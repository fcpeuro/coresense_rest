# frozen_string_literal: true

module CoresenseRest
  module Creatable
    def create(param)
      case param
      when Hash
        RequestWrite.new(full_path, headers, self, param).create
      when Array
        raise ArgumentError, 'Expected all items of array to be a Hash.' unless param.all { |i| i.is_a? Hash }

        param.each do |item|
          RequestWrite.new(full_path, headers, self, item.to_h).create
        end
      else
        raise ArgumentError, "Excepted Array or Hash, got: #{param.class.name}"
      end
    end
  end
end
