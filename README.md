# Hangman
A command line Hangman game built in Ruby.

This project was done as part of [The Odin Project](https://www.theodinproject.com/lessons/ruby-hangman), with a focus on Files/Serialization in Ruby.

## Instructions
To play, clone this repository and run in your shell from the project's root folder:
`ruby ./lib/main.rb`

Otherwise, try the [live demo](https://replit.com/@nathancabigao/hangman).

## About
This hangman game features save file support. The game creates save files in the form of JSON files containing instance variables of the game. Upon startup of the program, the user can load a previous save file, or simply start a new game. During the game, users can save the game before another turn to play at another time.