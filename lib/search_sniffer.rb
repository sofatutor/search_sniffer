# Adapted from http://www.insiderpages.com/rubyonrails/2007/01/get-referring-search-engine-keywords.html

module Sofatutor  #:nodoc:
  module SearchSniffer  #:nodoc:
    module ControllerMethods
      #   Creates @referring_search containing any referring search engine query minus stop words
      #
      # eg. If the HTTP_REFERER header indicates page referer as:
      #     http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a
      #   
      #     then this function will create:
      #     @referring_search = "Ruby Rails Houston"
      #   
      def sniff_referring_search
        # Check whether referring URL was a search engine result
        # uncomment out the line below to test
    		# request.env["HTTP_REFERER"] = "http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a"
        referer = request.env["HTTP_REFERER"]
        @referring_search = ReferringSearch.new(referer)
        true
      end # sniff_referring_search
    end # Module Controller Methods
      
      
      class ReferringSearch
        
        SearchReferers = {
              :google     => [/^http:\/\/(www\.)?google.*/, 'q'],
              :yahoo      => [/^http:\/\/search\.yahoo.*/, 'p'],
              :msn        => [/^http:\/\/search\.msn.*/, 'q'],
              :live        => [/^http:\/\/search\.live.*/, 'q'],
              :aol        => [/^http:\/\/search\.aol.*/, 'userQuery'],
              :altavista  => [/^http:\/\/(www\.)?altavista.*/, 'q'],
              :feedster   => [/^http:\/\/(www\.)?feedster.*/, 'q'],
              :lycos      => [/^http:\/\/search\.lycos.*/, 'query'],
              :alltheweb  => [/^http:\/\/(www\.)?alltheweb.*/, 'q']
            }
            
        StopWords = /\b(\d+|\w|about|after|also|an|and|are|as|at|be|because|before|between|but|by|can|com|de|do|en|for|from|has|how|however|htm|html|if|i|in|into|is|it|la|no|of|on|or|other|out|since|site|such|than|that|the|there|these|this|those|to|under|upon|vs|was|what|when|where|whether|which|who|will|with|within|without|www|you|your)\b/i
        
        attr_reader :search_terms # sanitized search terms
        attr_reader :raw # original terms as typed by user
        attr_reader :engine # search engine
      
        def initialize(referer)
          return if referer.blank?
          
          query_string = referer.split('?',2)[1]
          return if query_string.blank?
          
          SearchReferers.each do |engine,v|
            pattern,query_param_name = v
            next unless pattern.match(referer)
            
            @engine = engine
            
            params = CGI::parse(query_string)
            break unless params.has_key?(query_param_name)
            
            @raw = params[query_param_name].join(' ')
            @search_terms = @raw.gsub(StopWords,'').squeeze(' ')
            break
          end
        end #initialize
        
        # Return the referring search string instead of the object serialized into a string
        def to_s
          @search_terms
        end
        
      end # ReferringSearch
      
  end # Module SearchSniffer
end # Module Squeejee