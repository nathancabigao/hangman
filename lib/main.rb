# frozen-string-literal: true

require_relative 'game'

# Prompt user to start new game or load a previous one.
def start_game
  puts 'Welcome to Hangman! To start a new game, enter 1. To load a save file, press 2.'
  choice = 0
  until choice.between?(1, 2)
    choice = gets.to_i
    puts 'Invalid selection. Please enter 1 for new game, 2 for load save.' unless choice.between?(1, 2)
  end
  choice
end

game = Game.new
game.load_game if start_game == 2
game.play
# if loading a save, Game.new.from_json.play
