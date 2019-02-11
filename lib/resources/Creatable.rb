module CoresenseRest
  module Creatable

    def create param
      if param.is_a? Hash
        RequestWrite.new(full_path, headers, self, param).create
      elsif Array
        raise 'Invalid Params' unless param.all{|i| i.is_a? Hash}
        param.each do |item|
          RequestWrite.new(full_path, headers, self, item.to_h).create
        end
      else
        raise 'Invalid param'
      end
    end

  end
end