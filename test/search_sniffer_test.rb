require 'test/unit'
require 'search_sniffer'

class ReferringSearchTest < Test::Unit::TestCase

  def test_google
    referrer = "http://www.google.com/search?q=ruby+on+rails"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.engine, :google
    assert_equal sniffer.raw_search_terms, "ruby on rails"
    assert_equal sniffer.search_terms, "ruby rails"
  end

  def test_https_google_without_query_string
    referrer = "https://www.google.com"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.engine, :google
    assert_equal sniffer.raw_search_terms, nil
    assert_equal sniffer.search_terms, nil
  end

  def test_double_existing_param
    referrer = "http://www.google.com/search?q=ruby&q=rails"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.engine, :google
    assert_equal sniffer.raw_search_terms, "ruby rails"
    assert_equal sniffer.search_terms, "ruby rails"
  end

  def test_referrer_with_hashtag_syntax
    referrer = "https://www.google.de/?q=test#q=foo+bar"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.engine, :google
    assert_equal sniffer.raw_search_terms, "foo bar"
    assert_equal sniffer.search_terms, "foo bar"
  end

  def test_referrer_with_percent_syntax
    referrer = "http://www.google.com/?width=80%&height=80%"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.engine, :google
    assert_equal sniffer.raw_search_terms, nil
    assert_equal sniffer.search_terms, nil
  end

  def test_referrer_with_invalid_utf8
    referrer = "http://www.google.com/search?q=%FCbungen"
    sniffer = Sofatutor::SearchSniffer::ReferringSearch.new referrer
    assert_equal sniffer.engine, :google
    assert_equal sniffer.raw_search_terms, "�bungen"
    assert_equal sniffer.search_terms, "�bungen"
  end
end
