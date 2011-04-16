class ToTerminal < Outputter

# Class for printing output to a posix terminal.
# Outputter classes are placed in Query objects, where
# they are accessed as @output.
#
# They assume they are inside an object that has the @results array created
# by the XMLResultsParser.
#
# ToTerminal is the default outputter. New outputters can be passed
# in to query objects when they are created:
#
# query = Query.new :output => Meagaphone.new
#

  def self.<<(string)
    puts
    puts '---------------------------------------'.green
    puts string.magenta
    puts '---------------------------------------'.green
    puts
  end



  def announce(string)
    puts
    puts (string + '                        ').white_on_blue
    puts
  end


  private


  def print_scorer_output
    title = @results[:title] || nil
    score = @results[:score]
    query = @results[:query]

    puts "===== Query: #{query} =========== Comparison #{title}  ".black_on_white
    puts "Score: #{score}  ".red; puts
  end


  def print_result_header
    numfound = @results.first.numfound
    query = @results.first.query

    puts "Results for: #{query} ================================== Returned: #{numfound} ===".black_on_yellow; puts
  end


  def print_result_set
   if @results.first.numfound == '0'
      self.announce 'No results'
   else
      items = @results[1]

      items.each do |i|
        puts i.title + '  ' + i.pid.magenta + '  ' + i.score[0..4].red
        puts i.url.blue_with_underline if i.url
      end
    end
  end


  def print_result_footer

  end

end

