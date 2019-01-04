module CoresenseRest
  module Searchable

    def select
      Request.new(full_path, @headers, @query).select
    end

    def where(clause)
      Request.new(full_path, @headers, @query).where clause
    end

    def order(field)
      Request.new(full_path, @headers, @query).order field
    end

    def page_size(size)
      Request.new(full_path, @headers, @query).page_size size
    end

    def page(pg_num)
      Request.new(full_path, @headers, @query).page pg_num
    end

    def limit(max_result_count)
      Request.new(full_path, @headers, @query).limit max_result_count
    end

  end
end