require 'test/unit'
require 'search_sniffer'

class ReferringSearchTest < Test::Unit::TestCase

  def test_google
    referrer = "http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.raw_search_terms, "ruby on rails houston"
    assert_equal sniffer.search_terms, "ruby rails houston"
  end

end
