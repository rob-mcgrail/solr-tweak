class Terminal
#
# A painfull class of occasionally useful Terminal methods that I keep
# on hand for scripts that use the command line a lot...
#


  if !''.respond_to? :white
    raise 'Terminal needs the module Colourize to be mixed in to String'
  end

  STDOUT.sync = true

  @@memory = {
    :speed => 0.3   # Setting the defaut speed
  }

  def self.set_speed(x)
      @@memory[:speed] = x
  end

  def self.clear_strict
    print "\e[2J"
  end

  def self.clear(x = 0, y = 0)
    self.clear_strict
    self.place(x,y)
  end

  def self.clear_behind
    print "\e[1J"
  end

  def self.clear_ahead
    print "\e[0J"
  end

  def self.hide_cursor arg = :memory
    if arg == :memory
      print "\e[?25l"; @@memory[:cursor] = false
    elsif arg == :no_memory
      print "\e[?25l"
    else
      raise 'bad argument sent to Terminal.hide_cursor'
    end
  end

  def self.show_cursor arg = :memory
    if arg == :memory
      print "\e[?25h"; @@memory[:cursor] = true
    elsif arg == :no_memory
      print "\e[?25h"
    else
      raise 'bad argument sent to Terminal.hide_cursor'
    end
  end

  def self.cursor
    if @@memory.key? :cursor
      if @@memory[:cursor] == true
        self.hide_cursor
      else
        self.show_cursor
      end
    else
      self.hide_cursor
    end
  end

  def self.place(x = 0,y = 0)
    print "\e[#{x};#{y}f"
  end

  def self.raw_back(x = 1)
    print "\e[#{x}D"
  end

  def self.back(x = 1)
    self.raw_back(x + 1)
  end

  def self.raw_forward(x = 1)
    print "\e[#{x}C"
  end

  def self.forward(x = 1)
    self.raw_forward(x - 1)
  end

  def self.raw_up(x = 1)
    print "\e[#{x}A"
  end

  def self.up(x = 1)
    self.raw_up(x)
    self.raw_back
  end

  def self.raw_down(x = 1)
    print "\e[#{x}B"
  end

  def self.down(x = 1)
    self.raw_down(x)
    self.raw_back
  end

  def self.print_in_place(str, opts={})
    speed = opts[:speed] || @@memory[:speed]

    if str.index(' ')           # Checks for spaces
      str.each(' ') do |word|   # Breaks on spaces
        word.chomp!(' ')        # Removes trailing spaces
        print word              # Prints word
        sleep speed
        self.raw_back(word.length)  #Returns cursor to original position
        word.length.times do
          print ' '
        end
        self.raw_back(word.length)
      end

    else
      str.each_char do |c|      # Respects escape sequences ending in m (colours etc)
        if c == "\e"            # Checks for escape
          @holder = String.new
          @escapes = true
        end
        if @escapes == true     # While we are dealing with an escape,
          @holder += c          # collects sequence up in @holder
          if c == 'm'           # Once end of escape sequence has been added
            print @holder       # Prints the sequence, and sets back to false
            @escapes = false
          end
        else                    # While not dealing with an escape sequence, iterates as normal
          print c               # Prints character
          sleep speed
          self.raw_back         # Returns character to original position
        end
      end
    end
  end

  def self.bar(opts={})

    char = opts[:char] || ' '
    colour = opts[:colour] || :white

    self.hide_cursor(:no_memory) if @@memory[:cursor] == true || nil

    if char == ' '
      bar = char.send "#{colour.to_s}_on_#{colour.to_s}".to_sym
    else
      bar = char.send "#{colour}".to_sym
    end

    1000.times do
      print bar
      self.raw_back
      self.raw_forward
    end
    print "\e[0E" #add new line

    self.show_cursor if @@memory[:cursor] == true || nil
  end

  def self.border(str, opts={})

    char = opts[:char] || ' '
    colour = opts[:colour] || :white
    speed = opts[:speed] || 0
    padding = opts[:pad] || 1
    thick = opts[:thick] || 2

    self.hide_cursor(:no_memory) if @@memory[:cursor] == true || nil

    if char == ' '
      border = char.send "#{colour.to_s}_on_#{colour.to_s}".to_sym
    else
      border = char.send "#{colour}".to_sym
    end

    x = 4 + (padding * 4); y = 3 + (padding * 2)

    str.each_char do |c|
      if c == "\e"            # Checks for escapes
        @escapes = true
      end
      if @escapes == true     # While we are dealing with an escape,
        if c == 'm'           # Once end of escape sequence has been added
            @escapes = false
        end
      else
        x += 1
      end
    end

    self.forward    # This is a horrific hack

    thick.times do
      y.times do
        print border; sleep speed
        self.down
      end
      y.times do
        self.up
        self.raw_forward
      end
      self.raw_forward
    end


    (x - 4).times do
      print border; sleep speed

      self.down
      self.forward y - 1

      (y - 2).times {self.down}

      print border; sleep speed

      (y - 1).times {self.up; self.forward}
    end

    thick.times do
      y.times do
        print border; sleep speed
        self.down
      end
      y.times do
        self.up
        self.raw_forward
      end
      self.raw_forward
    end

    self.raw_back x - ((padding * 2) - (thick - 4))
    self.raw_down y - (2 + padding)

    print str

    (padding + 2).times {print "\e[0E"}

    self.show_cursor if @@memory[:cursor] == true || nil
  end

  class << self
    alias_method :silent, :hide_cursor
    alias_method :hold, :print_in_place
    alias_method :left, :back
    alias_method :right, :forward
  end

end

class TERM < Terminal
end

