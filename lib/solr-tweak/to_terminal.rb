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


  def announce(string)
    puts; puts (string + '                 ').white_on_blue; puts
  end


  private


  def print_result_header
    numfound = @results.first.numfound
    query = @results.first.query

    puts "Results for: #{query} ================================== Returned: #{numfound} ===".black_on_yellow
    puts
  end


  def print_result_set
   if @results.first.numfound == '0'
      self.announce 'No results'
   else
      items = @results[1]

      # Limits output by the class variable defined
      # and alterable in Outputter
      @@limit.times do |i|
        puts items[i].title + '  ' + items[i].pid.magenta + '  ' + items[i].score[0..4].red
        puts items[i].url.blue_with_underline if items[i].url
      end
    end
  end


  def print_result_footer

  end

end

