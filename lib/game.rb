# frozen-string-literal: true

# Static variables
MIN_CHARS = 5
MAX_CHARS = 12

# Class to run an instance of a hangman game.
class Game
  attr_reader :key, :guessed_letters, :incorrect_letters

  def initialize
    @word = random_word
    @key = Array.new(@word.size, '_')
    @remaining_guesses = 6
    @guessed_letters = []
    @incorrect_letters = []
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
    guess = player_guess
  end

  # Prompt the user to guess a letter, and returns the letter given.
  def player_guess
    valid = false
    until valid
      puts 'Guess a letter: '
      guess = gets.chomp
      validation = validate_guess(guess)
      valid = validation[0]
      puts validation[1] unless valid
    end
    guess
  end

  # Returns whether a guess was valid or not, along with an error message if needed.
  def validate_guess(guess)
    return [false, 'Your guess should only be one letter. Please try again.'] if guess.length > 1 || !guess.match(/[a-zA-Z]/)

    return [false, 'You guessed a letter that has already been guessed. Try again.'] if incorrect_letters.contains?(guess)

    [true, '']
  end
end
