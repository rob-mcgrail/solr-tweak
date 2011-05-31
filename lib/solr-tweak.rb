require 'rubygems'
require 'nokogiri'
require 'open-uri'

# $:.unshift PATH
require 'config/servers'

require 'lib/solr-tweak/utils/colourize'
require 'lib/solr-tweak/utils/terminal'

require 'lib/solr-tweak/request'
require 'lib/solr-tweak/xml_results_parser'
require 'lib/solr-tweak/query'
require 'lib/solr-tweak/outputter'
require 'lib/solr-tweak/to_terminal'
require 'lib/solr-tweak/scorer'

require 'lib/solr-tweak/seeds/requests'
require 'lib/solr-tweak/seeds/comparison_requests'

