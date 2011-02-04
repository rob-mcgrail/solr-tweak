class Outputter

# Template class for output objects. Children should do all the things below.
# See ToTerminal for an example child.

  # @@limit class variable sets a global limit for the printing out results.
  @@limit = 5

  # Set limit for printing of results: Outputter.limit 5
  def self.limit(i)
    @@limit = i
  end

  # A convenient way of printing results: @output << results
  def <<(results)
    @results = results
    print
  end

  # A catch-all way of printing arbitrary messages.
  def announce(string)
    puts 'Called announce from the template...'
  end

  private

  def print
    print_result_header
    print_result_set
    print_result_footer
  end


  def print_result_header
    puts 'Called print method from the template...'
  end


  def print_result_set
    puts 'Called print method from the template...'
  end


  def print_result_footer
    puts 'Called print method from the template...'
  end

end

