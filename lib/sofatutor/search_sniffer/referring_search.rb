module Sofatutor  #:nodoc:
  module SearchSniffer  #:nodoc:

    class ReferringSearch

      # Search engine detetion expressions
      SearchReferers = {
        :google     => [%r{^http://(www\.)?google.*}, 'q'],
        :yandex     => [%r{^http://(www\.)?yandex.*}, 'text'],
        :mail       => [%r{^http://go\.mail.*}, 'q'],
        :nigma      => [%r{^http://(www\.)?nigma.*}, 's'],
        :bing       => [%r{^http://(www\.)?bing.*}, 'q'],
        :ask        => [%r{^http://(www\.)?ask.*}, 'q'],
        :yahoo      => [%r{^http://search\.yahoo.*}, 'p'],
        :msn        => [%r{^http://search\.msn.*}, 'q'],
        :aol        => [%r{^http://search\.aol.*}, 'userQuery'],
        :altavista  => [%r{^http://(www\.)?altavista.*}, 'q'],
        :feedster   => [%r{^http://(www\.)?feedster.*}, 'q'],
        :lycos      => [%r{^http://search\.lycos.*}, 'query'],
        :alltheweb  => [%r{^http://(www\.)?alltheweb.*}, 'q']
      }

      # Words to exclude when compiling #search_terms
      StopWords = /\b(\d+|\w|about|after|also|an|and|are|as|at|be|because|before|between|but|by|can|com|de|do|en|for|from|has|how|however|htm|html|if|i|in|into|is|it|la|no|of|on|or|other|out|since|site|such|than|that|the|there|these|this|those|to|under|upon|vs|was|what|when|where|whether|which|who|will|with|within|without|www|you|your)\b/i

      attr_reader :search_terms # sanitized search terms
      attr_reader :raw_search_terms # original terms as typed by user
      attr_reader :engine # search engine

      def initialize(referer)
        return if referer.blank?

        query_string = referer.split('?',2)[1]
        return if query_string.blank?

        params = CGI::parse(query_string)
        SearchReferers.each do |engine, v|
          pattern, query_param_name = v
          next unless pattern.match(referer)

          @engine = engine

          break unless params.has_key?(query_param_name)

          @raw_search_terms = params[query_param_name].join(' ')
          @search_terms = @raw_search_terms.gsub(StopWords, '').squeeze(' ')
          break
        end
      end

      # Return the referring search string instead of the object serialized into a string
      def to_s
        @search_terms
      end

    end

  end
end
