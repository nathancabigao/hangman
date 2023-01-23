# frozen-string-literal: true

# Static variables
MIN_CHARS = 5
MAX_CHARS = 12

# Class to run an instance of a hangman game.
class Game
  attr_reader :key, :guessed_letters, :incorrect_letters, :remaining_guesses

  def initialize
    @word = random_word
    @key = Array.new(@word.size, '_')
    @remaining_guesses = 6
    @guessed_letters = []
    @incorrect_letters = []
    play
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
    puts "The word is #{@word.length} letters long. Good luck!"
    while key.include?('_') && remaining_guesses.positive?
      display_turn
      guess = player_guess
      check_guess(guess)
    end
    puts "Game over. The word was #{@word}!"
  end

  def display_turn
    puts "\n#{key.join(' ')}"
    puts "Remaining guesses: #{remaining_guesses}"
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
    if guess.length > 1 || !guess.match(/[a-zA-Z]/)
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
