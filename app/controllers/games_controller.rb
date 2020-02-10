require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (1...10).map do
    ('A'..'Z').to_a.sample
    end
  end

  def score
    @result_score = session[:score] || 0

    @grid = params[:word]
    @word = params[:new] # mot saisi dans le formulaire
    lettersFind = @word.upcase.chars # mot transformé en array, avec un array par caractères
    if @result = lettersFind.all? { |letter| lettersFind.count(letter) <= @grid.count(letter)}

      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      @word_serialized = JSON.parse(open(url).read)
      if @word_serialized["found"]
        @message = "Congratulation! #{@word.upcase} is a valid English Word!"
        @result_score += @word.length
      else
        @message = "Sorry but #{@word.upcase} does not seem to be a valid English Word..."
      end
    else
      @message = "Sorry but #{@word.upcase} can't be built out of #{@grid.gsub(' ', ', ')}"
    end
    session[:score] = @result_score
  end
end
