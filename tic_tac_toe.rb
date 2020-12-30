# frozen_string_literal: false

# module that holds the constant for victory
module Elements
  VICTORIOUS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7], [1, 4, 7], [2, 5, 8], [3, 6, 9]].freeze
end

# class that creates each player of the game
class Player
  attr_accessor :name
  attr_reader :choices

  @@num_of_player = 1
  def initialize(name)
    self.name = "#{name}(#{@@num_of_player})"
    self.name = "player#{@@num_of_player}" if self.name == ''
    @choices = []
    @@num_of_player += 1
  end

  def display_letter
    @letter
  end

  def to_s
    name
  end

  # protected
  def defining_choices(arg)
    @choices.push(arg)
  end

  def select_letter(letter)
    @letter = letter
  end
end

# class that defines the logic of the game
class Game < Player
  include Elements

  def self.restart
    @@num_of_player = 1
    print "Do you want to play again? Type either 'yes' or 'no': "
    choice = gets.chomp!.downcase
    case choice
    when 'yes'
      Game.start_game
    when 'no'
      nil
    else
      Game.restart
    end
  end

  def self.start_game
    grid = "\n\n\t\t 1 | 2 | 3\n\t\t---+---+---\n\t\t 4 | 5 | 6\n\t\t---+---+---\n\t\t 7 | 8 | 9\n\n\n"

    print 'player1, type your name: '
    player1 = Player.new(gets.chomp!)
    print "#{player1}, type your in-game letter (caps included): "
    player1_letter = gets.chomp!
    while player1_letter.length > 1 || player1_letter.empty? || player1_letter.ord < 65 ||
          player1_letter.ord > 90 && player1_letter.ord < 97 || player1_letter.ord > 122
      print "That's not valid, select other: "
      player1_letter = gets.chomp!
    end
    player1.select_letter(player1_letter)
    puts

    print 'player2, type your name: '
    player2 = Player.new(gets.chomp!)
    print "#{player2}, type your in-game letter (caps included): "
    player2_letter = gets.chomp!
    while player2_letter.length > 1 || player2_letter.empty? || player2_letter == player1_letter ||
          player2_letter.empty? || player2_letter.ord < 65 || player2_letter.ord > 90 && player2_letter.ord < 97 ||
          player2_letter.ord > 122
      print "That's not valid, select other: "
      player2_letter = gets.chomp!
    end
    player2.select_letter(player2_letter)

    number_of_moves = 0
    puts grid
    while number_of_moves < 9
      VICTORIOUS.each do |el|
        if el - player1.choices == []
          puts "#{player1} wins!"
          Game.restart
          return "#{player1} has won the game."
        end
        next unless el - player2.choices == []

        puts "#{player2} wins!"
        Game.restart
        return "#{player2} has won the game."
      end
      if number_of_moves.even?
        puts "Choose your move, #{player1.name}"
        p1_chooses = gets.chomp!
        while grid.include?(p1_chooses) == false
          puts "That's not a valid move! Select again:"
          p1_chooses = gets.chomp!
        end
        player1.defining_choices(p1_chooses.to_i)
        choice1 = player1.choices.last.to_s
        grid.gsub!(choice1, player1.display_letter)
      else
        puts "Choose your move, #{player2.name}"
        p2_chooses = gets.chomp!
        while grid.include?(p2_chooses) == false
          puts "That's not a valid move! Select again:"
          p2_chooses = gets.chomp!
        end
        player2.defining_choices(p2_chooses.to_i)
        choice2 = player2.choices.last.to_s
        grid.gsub!(choice2, player2.display_letter)
      end
      puts grid
      number_of_moves += 1
      if number_of_moves == 9
        puts "It's a tie!"
        Game.restart
      end
    end
  end
end

Game.start_game
