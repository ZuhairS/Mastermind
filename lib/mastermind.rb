class Code
  attr_reader :pegs

  PEGS = {
    "r" => "Red",
    "g" => "Green",
    "b" => "Blue",
    "y" => "Yellow",
    "o" => "Orange",
    "p" => "Purple"
  }.freeze

  def initialize(pegs)
    @pegs = pegs
  end

  def self.parse(code)
    pegs = []
    code.downcase.each_char do |color|
      raise "That not a valid color!" if !PEGS.include?(color)
      pegs << PEGS[color]
    end
    Code.new(pegs)
  end

  def self.random
    pegs = []
    4.times { pegs << PEGS.values[rand(5)] }
    Code.new(pegs)
  end

  def [](index)
    pegs[index]
  end

  def exact_matches(code)
    (0..3).count { |idx| self[idx] == code[idx] }
  end

  def near_matches(code)
    #Counts matching values unless values have been matched
    #before (storing indices) or they share the same index
    counted_idx1, counted_idx2 = [], []
    count = 0
    (0..3).each do |idx1|
      (0..3).each do |idx2|
        if self[idx1] == code[idx2] &&
          !counted_idx1.include?(idx1) &&
          !counted_idx2.include?(idx2) &&
          self[idx2] != code[idx2]
          count += 1
          counted_idx1 << idx1
          counted_idx2 << idx2
        end
      end
    end
    count
  end

  def ==(code)
    (0..3).all? { |idx| self[idx] == code[idx] }
  end

end

class Game
  attr_reader :secret_code

  def initialize(secret_code = Code.random)
    @secret_code = secret_code
  end

  def get_guess
    print "\nEnter your guess (eg: RBOO, gbpy): "
    guess = gets.chomp
    Code.parse(guess)
  end

  def display_matches(code)
    puts "\n\nYou exact matches: #{secret_code.exact_matches(code)}"
    puts "Your near matches: #{secret_code.near_matches(code)}"
  end

  def play
    puts "Welcome to Mastermind: The Game"
    puts "\nColor Choices: Red, Green, Blue, Yellow, Orange, Purple\n"
    guess = get_guess
    display_matches(guess)
    until secret_code.exact_matches(guess) == 4
      guess = get_guess
      display_matches(guess)
    end
    puts "Congrats! You are a true Mastermind! ;)"
  end

end

if __FILE__ == $PROGRAM_NAME
  new_game = Game.new
  new_game.play
end
