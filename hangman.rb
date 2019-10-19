#require 'sinatra'
#require 'sinatra/reloader' 

def clean_word_bank(text_file)
  raw_file = File.open(text_file, "r")
  clean_file = File.open("word_bank.txt", "w+")
  raw_words = raw_file.readlines
  #words = []
  raw_words.each do |x|
    x.strip!
    if x.match(/[A-Z]+$/) || x.length < 5 || x.length > 12
      next
    else
      #words << x.downcase
      clean_file.puts x.downcase
    end
  end
  #return words
end

class Game
  
  def initialize(params)
    @word = pick_word().strip
    @lives = 5
    @player_guesses = params[:player_guesses]
    @mistakes = params[:mistakes]
  end

  def play_game()
    @word.length.times {@player_guesses << "_"}
    display

    while @lives > 0
      guess = gets.chomp
      response = handle_input(guess)
      break if response == "break"
    end
  end

private

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
    load_file.close
    @player_guesses = load_guesses
    @mistakes = load_mistakes
  end

  def pick_word()
    word_bank = File.open("word_bank.txt", "r")
    line_count = `wc -l "#{"word_bank.txt"}"`.strip.split(' ')[0].to_i 
    rand(line_count-1).times { word_bank.gets }
    word = word_bank.gets
    word_bank.close
    return word
  end

  def display()
    print "#{@player_guesses.join("")}   lives: #{@lives}  mistakes: #{@mistakes.join(", ")}\n"
  end
 
  def handle_input(guess)
    if guess == "save"
      save_game()
      display
    elsif guess == "load"
      load_game()
      display
    elsif guess == "exit"
      return "break"
    elsif guess.length == 1 && guess.match(/[a-zA-Z]/)
      play_guess(guess)
    else
      puts "invalid choice"
      display
    end
  end

  def play_guess(guess)
    if @word.include?(guess)
      #next if guess == "" || guess.length > 1
      indexes = @word.chars.each_with_index.select {|x, i| x == guess}.map{|pair| pair[1]}
      for i in indexes
        @player_guesses[i] = guess
      end
      display
    else
      #next if guess == "" || guess.length > 1
      @lives -= 1
      @mistakes << guess
      display
    end 
  end

end

game = Game.new({player_guesses: [], mistakes: []})
game.play_game()


#get '/' do
#  erb :index 
#end