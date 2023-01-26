# frozen-string-literal: true

# Libraries
require 'json'

# Static variables
MIN_CHARS = 5
MAX_CHARS = 12
MAX_INCORRECT = 6

# Class to run an instance of a hangman game.
class Game
  attr_reader :key, :guessed_letters, :incorrect_letters, :remaining_guesses

  def initialize
    @word = random_word
    @key = Array.new(@word.size, '_')
    @remaining_guesses = MAX_INCORRECT
    @guessed_letters = []
    @incorrect_letters = []
  end

  def save_game
    print 'Enter save file name: '
    valid = false
    until valid
      save_name = gets.chomp
      Dir.mkdir('save') unless File.exist?('save')
      next if File.exist?("save/#{save_name}")

      File.open("./save/#{save_name}.json", 'w') { |f| f.write(to_json) }
      exit
    end
  end

  def to_json(*_args)
    JSON.dump({
                word: @word,
                key: @key,
                remaining_guesses: @remaining_guesses,
                guessed_letters: @guessed_letters,
                incorrect_letters: @incorrect_letters
              })
  end

  def from_json(save)
    data = JSON.parse(File.read(save))
    @word = data['word']
    @key = data['key']
    @remaining_guesses = data['remaining_guesses']
    @guessed_letters = data['guessed_letters']
    @incorrect_letters = data['incorrect_letters']
    File.delete(save)
  end

  def load_game
    # Guard clause, if there are no saves, just start a new game
    unless File.exist?('./save') && Dir.glob('./save/*').length.positive?
      puts "No saves found. Starting new game...\n"
      return
    end
    # List all saves
    saves = Dir.children('save')
    puts "\nSave files"
    saves.each_with_index { |save_name, index| puts "#{index + 1}: #{save_name}" }
    # Ask user for save
    choice = load_game_choice(saves)
    from_json("./save/#{saves[choice - 1]}")
  end

  def load_game_choice(saves)
    valid = false
    until valid
      print "\nPlease enter the number of the save file you want to load: "
      choice = gets.to_i
      valid = true if choice.between?(1, saves.length)
      puts 'Invalid input. Please choose a valid save number.' unless valid
    end
    choice
  end

  # Reads from the dictionary file, and returns a random eligible word
  def random_word
    words = []
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    dictionary.each { |word| words << word.chomp if word.chomp.length.between?(MIN_CHARS, MAX_CHARS) }
    dictionary.close
    words.sample
  end

  def play
    puts "\nThe word is #{@word.length} letters long. Good luck!"
    while key.include?('_') && remaining_guesses.positive?
      display_turn
      guess = player_guess
      check_guess(guess)
    end
    puts "\nGame over. The word was #{@word}!"
    puts "You won with #{MAX_INCORRECT - remaining_guesses} incorrect guesses!" unless key.include?('_')
  end

  def display_turn
    puts "\n#{key.join(' ')}"
    puts "Incorrect letters: #{incorrect_letters.join(' ')}"
    puts "Remaining guesses: #{remaining_guesses}"
    puts "\nTo save the game, type 'save'."
  end

  # Prompt the user to guess a letter, and returns the letter given.
  def player_guess
    valid = false
    until valid
      print 'Guess a letter: '
      guess = gets.chomp.downcase
      validation = validate_guess(guess)
      valid = validation[0]
      puts validation[1] unless valid
    end
    guess
  end

  # Returns whether a guess was valid or not, along with an error message if needed.
  def validate_guess(guess)
    if guess == 'save'
      save_game
    elsif guess.length > 1 || !guess.match(/[a-zA-Z]/)
      [false, 'Your guess should only be one letter. Please try again.']
    elsif guessed_letters.include?(guess)
      [false, 'You guessed a letter that has already been guessed. Try again']
    else
      [true, '']
    end
  end

  # Checks if the player's guess was in the word, and updates the key if it was.
  # Also changes the number of remaining guesses if the guess was incorrect.
  def check_guess(guess)
    guessed_letters << guess
    # if the guess contains the word, update the key with that letter.
    if @word.include?(guess)
      indices = (0..@word.length).find_all { |index| @word[index] == guess }
      indices.each { |index| @key[index] = guess }
    # Otherwise, add that guess to the incorrect letters, and change guess count.
    else
      incorrect_letters << guess
      @remaining_guesses -= 1
    end
  end
end
