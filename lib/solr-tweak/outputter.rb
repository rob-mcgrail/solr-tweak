class Outputter

# Template class for output objects. Children should do all the things below.
# See ToTerminal for an example child.  
  
  def self.<<(string)
    puts string
  end

  # A convenient way of printing results: @output << results
  def <<(arg)
    if arg.is_a? Array
      @results = arg
      print_results
    elsif arg.is_a? String
      self.announce arg
    elsif arg.is_a? Fixnum
      self.announce arg.to_s
    elsif arg.is_a? Hash
      @results = arg
      print_scorer_output
    else
      
    end
  end


  # A catch-all way of printing arbitrary messages.
  private

  def announce(string)
    puts 'Called announce from the template...'
  end
  
  
  def print_scorer_output
    puts 'Called print_scorer_output from the template...'
  end


  def print_results
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

