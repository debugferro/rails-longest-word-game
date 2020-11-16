require 'open-uri'
require 'json'

class GamesController < ApplicationController
  before_action :set_letters

  def new
  end

  def score
    @grid = params[:letters].gsub(/\s+/, '')
    @user_input = params[:word]
    @result = run_game(@user_input, @grid)
  end

  private

  def set_letters
    @letters = []
    10.times do
      random_num = rand(65..90)
      @letters << random_num.chr
    end
  end

  def open_dictionary(user_input)
    api_url = "https://wagon-dictionary.herokuapp.com/#{user_input}"
    file = open(api_url).read
    JSON.parse(file)
  end

  def included?(user_input, grid)
    user_input.chars.all? { |letter| user_input.count(letter) <= grid.count(letter) }
  end

  def define_result(dictionary_output, result)
    if dictionary_output['found']
      result[:message] = 'well done'
    elsif !dictionary_output['found']
      result[:message] = 'not an english word'
    elsif (grid.chars - attempt.chars).count.positive?
      result[:message] = 'some letters are overused'
    end
    result
  end

  def run_game(user_input, grid)
    dictionary_output = open_dictionary(user_input)
    result = { score: 0, message: '' }
    user_input = user_input.upcase

    if included?(user_input, grid)
      define_result(dictionary_output, result)
    else
      result[:message] = 'not in the grid'
    end
    result
  end
end
