class Scorer
  # Takes two queries, or a query and a pre populated reference ResultSet,
  # and returns a score, judging the first query's similarity to the second.
  #
  # Used for testing new Requests against ideal results.
  #
  # Scorer.new(query1, query2)
  # Scorer.new(query, ResultTest)

  def initialize(actual, ideal, opts = {})
    @actual = actual.results
    @request = actual.request
    @term = @actual.first.query

    @ideal = quack(ideal)

    @score = 0

    # Since it's all that goes on in here, immediately score
    # the results.
    score

    puts @score
  end


  private

  # Allows either a full query, or a predefined ResultsSet object,
  # for the second argument.
  def quack(arg)
    if arg.is_a? Query
      resultset = arg.results
    elsif arg.is_a? ResultSet
      resultset = arg
    else
      raise 'Passing the scorer the wrong sort of reference object. Query or ResultSet are valid.'
    end
    resultset
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
    @score
  end



end

