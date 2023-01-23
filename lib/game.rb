# frozen-string-literal: true

# Static variables
MIN_CHARS = 5
MAX_CHARS = 12

# Class to run an instance of a hangman game.
class Game
  attr_reader :word, :key

  def initialize
    @word = random_word
    @key = Array.new(word.size, '_')
  end

  # Reads from the dictionary file, and returns a random eligible word
  def random_word
    words = []
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    dictionary.each { |word| words << word.chomp if word.chomp.length.between?(MIN_CHARS, MAX_CHARS) }
    dictionary.close
    words.sample
  end
end
