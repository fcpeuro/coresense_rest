# frozen_string_literal: true

module CoresenseRest
  class RequestRead
    include HTTParty

    def initialize(root, headers, request_class, query = '')
      @headers = headers
      @root = root
      @query = query
      @request_class = request_class
    end

    def select
      response = HTTParty.get(current_path, headers: @headers, format: :json)
      if response.code == 404
        # ? implies a where clause was used, so user was searching for a list of items
        if current_path.match(/\?/)
          return []
        else
          # lack of ? implies find, so return a singular nil
          return nil
        end
      end
      raise response.body unless response.code == 200

      @request_class.parse_self response.body
    end

    def where(clause)
      # No support for OR in chain
      query_string = parse_query(clause)
      self.class.new(@root, @headers, @request_class, "#{@query}&#{query_string}")
    end

    def order(field)
      self.class.new(@root, @headers, @request_class, "#{@query}&order=#{field}")
    end

    def page_size(size)
      self.class.new(@root, @headers, @request_class, "#{@query}&page_size=#{size}")
    end

    def page(pg_num)
      self.class.new(@root, @headers, @request_class, "#{@query}&page=#{pg_num}")
    end

    def limit(max_result_count)
      self.class.new(@root, @headers, @request_class, "#{@query}&max=#{max_result_count}")
    end

    def current_path
      return @root if nil_or_empty? @query

      @root + '?' + @query
    end

    private

    def nil_or_empty?(value)
      value.nil? || value.empty?
    end

    def parse_query(clause)
      if clause.is_a? String
        if clause =~ / or /i
          raise 'OR operators are not supported by the API as this time.'
        end

        clause.split(/ and /i).map { |clauses| "q[]=#{clauses}" }.flatten.join('&')
      elsif clause.is_a? Hash
        clause.map { |key, value| "q[]=#{key}=#{value}" }.join('&')
      else
        raise 'Invalid Where Clause Provided'
      end
    end
  end
end

# Params:
# page_size, Max 100
# page, integer
#
# Filter
# /v1/product?q[]=base_price>=5&q[]=base_price<=10
# q[]
#
# GET /v1/product?order=part_num
# order each class has a fieldset of valid ordering fields
#
#
