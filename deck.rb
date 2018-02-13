require_relative 'exception'

class Card

  include Comparable

  attr_reader :value, :suit

  @@suits = [:SPADES, :CLUBS, :DIAMONDS, :HEARTS]
  @@values = (1..13).to_a
  @@values_to_words = {
    1  => :ACE,
    2  => :TWO,
    3  => :THREE,
    4  => :FOUR,
    5  => :FIVE,
    6  => :SIX,
    7  => :SEVEN,
    8  => :EIGHT,
    9  => :NINE,
    10 => :TEN,
    11 => :JACK,
    12 => :QUEEN,
    13 => :KING }

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def <=>(other)
    @value > other.value ? 1 : @value < other.value ? -1 : 0
  end

  def to_s
    "#{@@values_to_words[@value]} OF #{@suit}"
  end

  def inspect
    "[Card] value: #{@value}, suit: #{@suit}"
  end

  def self.generate_random
    Card.new(@@values.sample, @@suits.sample)
  end

  def self.suits
    @@suits
  end

  def self.values
    @@values
  end
end



class Deck

  attr_accessor  :deck, :drawn

  # These are all the cards we will use.
  # Cards are immutable once created, so no need to make a bunch of copies.
  @@cards = Card.values.map{|v| Card.suits.map{ |s| Card.new(v, s) }}.flatten

  def initialize(with_jokers = false)
    @deck = @@cards.clone.shuffle!
    @drawn = []
  end 

  def inspect
    "[Deck] Cards left: #{@deck.length}, Cards drawn: #{@drawn.length}"
  end

  def reset!
    # Merges & shuffles cards back together in @deck, resets @drawn
    @deck = @deck + @drawn
    @drawn = []
    @deck.shuffle!
  end

  def draw(n=1)
    # Here we check if we can actually draw
    if n > @deck.length
      raise Library.DeckError
    end

    if n == 1
      # shifts 1st card off of @deck and pushes it onto @drawn.
      @drawn << @deck.shift
      return @drawn[-1]
    else
      # shifts <n> cards off of @deck and concatenates them onto @drawn
      @drawn += @deck.shift(n)
      return @drawn.slice(-n, n)
    end

  end
end
