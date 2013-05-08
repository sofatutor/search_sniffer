module Sofatutor  #:nodoc:
  module SearchSniffer  #:nodoc:

    class ReferringSearch

      SearchReferers = {
        :google     => [/^http:\/\/(www\.)?google.*/, 'q'],
        :yandex     => [/^http:\/\/(www\.)?yandex.*/, 'text'],
        :mail       => [/^http:\/\/go\.mail.*/, 'q'],
        :nigma      => [/^http:\/\/(www\.)?nigma.*/, 's'],
        :bing       => [/^http:\/\/(www\.)?bing.*/, 'q'],
        :ask        => [/^http:\/\/(www\.)?ask.*/, 'q'],
        :yahoo      => [/^http:\/\/search\.yahoo.*/, 'p'],
        :msn        => [/^http:\/\/search\.msn.*/, 'q'],
        :aol        => [/^http:\/\/search\.aol.*/, 'userQuery'],
        :altavista  => [/^http:\/\/(www\.)?altavista.*/, 'q'],
        :feedster   => [/^http:\/\/(www\.)?feedster.*/, 'q'],
        :lycos      => [/^http:\/\/search\.lycos.*/, 'query'],
        :alltheweb  => [/^http:\/\/(www\.)?alltheweb.*/, 'q']
      }

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
