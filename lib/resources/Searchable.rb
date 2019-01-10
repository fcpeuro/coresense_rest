module CoresenseRest
  module Searchable

    def select
      RequestRead.new(full_path, headers, self, @query).select
    end

    def where(clause)
      RequestRead.new(full_path, headers, self, @query).where clause
    end

    def order(field)
      RequestRead.new(full_path, headers, self, @query).order field
    end

    def page_size(size)
      RequestRead.new(full_path, headers, self, @query).page_size size
    end

    def page(pg_num)
      RequestRead.new(full_path, headers, self, @query).page pg_num
    end

    def limit(max_result_count)
      RequestRead.new(full_path, headers, self, @query).limit max_result_count
    end

  end
end