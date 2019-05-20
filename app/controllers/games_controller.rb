require 'open-uri'
require 'json'
require 'date'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @end_time = Time.now
    @input = params[:input]
    @letters = params[:letters]
    @result = score_message(@input, @letters)
  end

  def generate_grid(grid_size)
    alphabet_array = ('A'..'Z').to_a
    alphabet_array.reduce([]) { |acc| acc << alphabet_array.sample }.slice(0, grid_size)
    # TODO: generate random grid of letters in "ARRAY"
  end

  def score_message(attempt, grid)
    if word_checker?(attempt.upcase, grid)
      if english_checker?(attempt)
        score = score_calculate(attempt)
        [score, 'well done']
      else
        [0, 'not an english word']
      end
    else
      [0, 'not in the grid']
    end
  end

  def english_checker?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def word_checker?(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
    # Returns true or false
  end

  def score_calculate(attempt)
    attempt.size
    # Returns interger
  end
end
