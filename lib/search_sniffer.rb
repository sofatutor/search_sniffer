require 'sofatutor/search_sniffer/version'
require 'sofatutor/search_sniffer/referring_search'
require 'sofatutor/search_sniffer/controller_methods'

ActionController::Base.send :include, Sofatutor::SearchSniffer::ControllerMethods
