require_relative './spec_helper'
require_relative '../twitonomy_parser'
require 'pry'

describe TwitonomyParser do
  let(:csv_line) { %q(14978,@masaluko1,masa,"Entrepreneur, Stocks/Forex trader.",,,en,2015-06-08,3239519168,613,1006,2984,14,326,2019-03-01 16:34:27,"It's a beast, I am still riding https://t.co/8DvTZhzKud",,)}
  it '' do
    binding.pry
    TwitonomyParser.parse(csv_line)
  end
end
