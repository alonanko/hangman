def clean_word_bank(text_file)
  raw_file = File.open(text_file, "r")
  raw_words = raw_file.readlines
  words = []
  raw_words.each do |x|
    x.strip!
    if x.match(/[A-Z]+$/) || x.length < 5 || x.length > 12
      next
    else
      words << x.downcase
    end
  end
  return words
end

class Game
  
  def initialize(word)
    @word = word
    @lives = 3
    @player_guesses = []
    @mistakes = []
  end

  def save_game()
    print "file to save in?  "
    filename = gets.chomp
    save_file = File.open(filename, "w+")
    save_file.print "#{@word}\n"
    save_file.print "#{@player_guesses.join("")}\n"
    save_file.print "#{@mistakes.join("")}\n"
  end

  def load_game()
    load_guesses = []
    load_mistakes = []
    print "file to load?  "
    filename = gets.chomp
    load_file = File.open(filename, "r")
    @word = load_file.readline
    load_guesses = load_file.readline.chars.each do |x|
      load_guesses << x
    end
    load_mistake = load_file.readline.chars.each do |x|
      load_mistakes << x
    end 

    @player_guesses = load_guesses
    @mistakes = load_mistakes
  end

  def play_game()
    puts @word
    @lives = 3
    @word.length.times {@player_guesses << "_"}
    display = lambda { print "#{@player_guesses.join("")}   lives: #{@lives}  mistakes: #{@mistakes.join(", ")}\n" }
    display.call

    while @lives > 0
      guess = gets.chomp
      if guess == "save"
        save_game()
        break
      end
      if guess == "load"
        load_game()
        display.call
      end
      if @word.include?(guess)
        next if guess == "" || guess.length > 1
        indexes = @word.chars.each_with_index.select {|x, i| x == guess}.map{|pair| pair[1]}
        for i in indexes
          @player_guesses[i] = guess
        end
        display.call
      else
        next if guess == "" || guess.length > 1
        @lives -= 1
        @mistakes << guess
        display.call
      end 
    end
  end
end

words = clean_word_bank("5desk.txt")
game_word = words[rand(words.length-1).floor]
game = Game.new(game_word)
game.play_game()