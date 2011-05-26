class Request
  require 'cgi'

  attr_accessor :base, :q, :explain

  BASE = 'http://search.tki.org.nz:8983/solr/select?'

  # Values set at initialize can always be overwritten
  # by seed.
  def initialize
    @q = ''
    @fl = '*,+score'
    @dismax = nil
		@explain = nil
  end

  # A class the populated the request with a hash of values.
  # Unfinished.
  def seed(hash)

    hash.each do |k,v|

      k = '@' + k.to_s
      self.instance_variable_set(k.to_sym, v)
    end

    # You need this... (or it returns the last item from the iterator)
    self
  end

  # Returns the full request. Called by the get_results method
  # in Query.
  def full
    request = String.new
    request << BASE
    request << 'q=' + @q
    request << '&fl=' + @fl
    request << '&sort=score+desc'
    request << '&rows=' + $limit.to_s

    if @dismax == true
      request << '&defType=dismax'
    end

		if @explain == true
      request << '&debugQuery=true'
		end

    old = Request.new.instance_variables.collect {|s| s.to_s}
    current = self.instance_variables.collect {|s| s.to_s}

    vars = current - old

    if vars != nil
      vars.each do |var|
        if var.is_a? String
          request << '&' + var.to_s.gsub('@', '') + '=' + self.instance_variable_get(var).to_s
        end
      end
    end

    request
  end

end

