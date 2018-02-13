
require_relative 'actor'
require_relative 'deck'
require_relative 'interactive'

# Structure of a gambling game:
# Make wager
# play game
# win? award wager
# lose? lose wager
#
# Some games require multiple inputs
#
LowestCard = Card.new(3, :SPADES)
HighestCard = Card.new(11, :SPADES)

def high_or_low(actor)
  initial_wager = prompt("Wager? Max: #{actor.wallet}").to_i
  deck = Deck.new()
  # Clear out any cards that are too high or low to play with
  deck.deck.reject! { |card| card < LowestCard ||
                             card > HighestCard }

  # Ugly spaghetti code
  # "Better to have it done and ugly"
  cur_card = deck.draw
  next_card = deck.draw
  guess = prompt("Card is #{cur_card}\nnext is higher(H) or lower(L)?")
  guess_high = guess.upcase == "H"
  puts "Next card is #{next_card}"
  #handle winning conditions first
  if next_card < cur_card && !guess_high || next_card > cur_card && guess_high
    puts "You won!"
    actor.wallet.deposit(initial_wager)
  else
    puts "You lost!"
    actor.wallet.withdraw(initial_wager)
  end
end

