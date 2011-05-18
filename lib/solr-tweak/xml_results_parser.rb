module XMLResultsParser
  require 'ostruct'

# A complex and ugly class, due to the madening variety of XML returned by
# the TKI search.
#
# The Parser is mixed in to Query, which calls #parse, passing in the raw results xml
# from Nokogiri. Values are pulled out in three blocks - a header (info about the results),
# a body (an array of results-proper), and a footer (unused at the moment). These are placed in
# the @results Array. This @results array is closely coupled to the Outputter classes, so if things change
# here, that's what will break. Also the Scorer and other analysis classes...

# Should probably make an interface for this class.

  def parse(results, opts ={})

    defaults = {
      :query => '',
    }

    @query = opts[:query] || defaults[:query]

    @raw_results = results

    @parsed_results = Array.new

    @parsed_results << get_result_header
    @parsed_results << get_result_body
    @parsed_results << get_result_footer

    @results
  end


  private

  # Flexibility over readibility :|  the @@fields hash contains
  # arbitrarily names of xml values and the xpath for locating them in the xml.
  #
  # This is then used to dynamically declare a host of methods called
  # get_pids, get_titles, etc.
  #
  # This is repeated throughout the class. Simple add a name => xpath
  # pair below, and it will end up in the individual results ostructs in the @results[1] Array.
  @@fields = {
    :url => '//arr[@name="url"]',
    :title => '//str[@name="title"]',
    :score => '//float[@name="score"]',
    :pid => '//str[@name="id"]',
    :ezhost => '//arr[@name="meta_installation_url_s"]',
    :ezpath => '//arr[@name="meta_url_alias_s"]',
    :eztitle => '//arr[@name="title_t"]/str',
    }

  @@fields.each do |k,v|
    send :define_method, "get_#{k}s" do |xml|
      node = xml.xpath(v)
      if node.first
        return node.first.content
      else
        # Some records return some fields and not others, so just
        # return nil in those cases, and let XMLResultsParser#map sort it out
        # at the end.
        nil
      end
    end
  end

  # Populates the first part of the @results array.
  def get_result_header
    @results_header = OpenStruct.new

    @results_header.numfound = @raw_results.xpath('//result[@name="response"]').first.attributes['numFound'].to_s
    @results_header.query = @query

    @results_header
  end

  # Populates the second part of the results array.
  #
  # Creates an array of indidivual results, each an ostruct with values
  # available like: x.title, x.pid etc...
  def get_result_body

    # Find individual records
    docs = @raw_results.xpath('//doc')
    tmp = Array.new
    # Iterate through the records
    docs.each do |doc|
      # A workaround for what I consider to be extremely odd Nokogiri
      # behavior, but which will turn out to be due to my misunderstanding
      # the library, or xml in general...
      doc = Nokogiri::XML.parse doc.to_s
      h = Hash.new
      # Iterate through @@fields hash, running each get_things method, and
      # placing the result in an appropriately names hash entry.
      @@fields.each do |k,v|
        r = self.send("get_#{k}s".to_sym, doc)
        h["#{k}s".to_sym] = r
      end
      tmp << h
    end

    result_body = Array.new
    # Iterate through the hashes, converting to ostructs.
    tmp.length.times do |i|
      x = OpenStruct.new
      # Iterate through @@fields again, creating openstruct entries, assigned
      # the values of the appropriate hash entry. Could just let OpenStruct do
      # this via .new(hash), but the names wouldn't be singular... :|
      @@fields.each do |k,v|
        x.send("#{k}=", tmp[i]["#{k}s".to_sym])
      end
      x.rank = i
      result_body << x
    end
    # Pass everything so far to XMLResultsParser#map
    # which sorts out all the crazy inconsistencies between records...
    map result_body
  end


  def get_result_footer
    nil
  end

  # A whole bunch of craziness to make records without out PID in the xml, or
  # a URL, etc etc all be treated the same way. Ugly stuff. How is this dealt with
  # on the channel??
  def map(results)
    if results.length < 1
      return results
    else
      results.each do |r|
        
        # Making a full url out of the horrible object returned in the xml/xpath
        if r.url
          r.url = r.url.inject('') {|url, line| url + line.gsub('  ','').chomp}
        end
        
        if r.title == nil
          r.title = r.eztitle
          if r.title == nil
            r.title = ''
          end
        end

        if r.url == nil
          if r.ezhost != nil
            r.url = r.ezhost + r.ezpath
          else
            r.url = r.title
          end
        end
        r.pid = 'No TKI ID' if r.pid == nil
      end
    end
  end

end

