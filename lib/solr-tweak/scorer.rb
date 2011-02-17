class Scorer
  # Takes two queries, or a query and a pre populated reference ResultSet,
  # and returns a score, judging the first query's similarity to the second.
  #
  # Used for testing new Requests against ideal results.
  #
  # Scorer.new(query1, query2)
  # Scorer.new(query, ResultTest, :query => 'thing')

  def initialize(actual, ideal, opts = {})

    @score = 0
    
    @actual_complete = actual
    @ideal_complete = ideal
    

    defaults = {
      :output => ToTerminal.new,
      :title => nil,
      :search_term => nil
    }

    @output = defaults[:output] || opts[:output]
    @title = defaults[:title] || opts[:title]
    @search_term = defaults[:search_term] || opts[:search_term]

    # If we passed in a query as an option, load that in
    # this is necessary if these objects haven't done queries yet
    set_search_term @search_term if @search_term != nil
    @actual = @actual_complete.results
    # Quack handles both queries and resultset objects, 
    # and adds the actual object's query to ideal if necessary.
    
    @ideal = quack(@ideal_complete)
        
    @request = actual.request

    # Since it's all that goes on in here, immediately score
    # the results.

    @output << score
  end


  private

  # Allows either a full query, or a predefined ResultsSet object,
  # for the second argument.
  def quack(arg)
    if arg.is_a? Query
      # Handle it if someone passed in a used actual, but an unused ideal
      if arg.q == ''
        puts arg.q
        arg.term @actual_complete.q
      end
      resultset = arg.results
    elsif arg.is_a? ResultSet
      resultset = arg
    else
      raise 'Passing the scorer the wrong sort of reference object. Query or ResultSet are valid.'
    end
    resultset
  end
  
  
  def set_search_term(query)
    @actual_complete.term @search_term
    @ideal_complete.term @search_term if @ideal_complete.is_a? Query
  end


  def score
    i = 0
    @actual[1].each do |act|
      i += 1
      # Keep in scope, for setting in the block
      act_rank = 0
      # Capture the rank of the actual result, and return the ideal record based
      # on a match of the url string.
      match = @ideal[1].detect {|ide| act_rank = act.rank.to_i; ide.url == act.url}
      # Awards for matches begin here:
      if match
        ide_rank = match.rank.to_i

        # Give some bonuses for near or direct matches for the
        # top few results
        case i
        when 1
          @score += 10 if ide_rank == 0 or 1
        when 2
          @score += 5 if ide_rank < 3
        when 3
          @score += 5 if ide_rank < 4
        end

        # Give a basic prize for matching at all.
        @score += 10
        # Temper that with how important a match is was (high matches are better)
        @score -= ide_rank/2
        # Add points for how close the rankings of the matched items were.
        # This is compounded positively for the top three results in the case
        # switch above.
        @score += 10 - (ide_rank - act_rank).abs
      end
    end
    # Create a results hash. The @output << method knows a hash means it's scorer results...
    @results = {:score => @score, :title => @title, :query => @actual_complete.q}
  end


end

