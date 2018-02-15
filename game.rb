
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

# I started to get lost in the probability with this one
# But I don't really have time to work through all that
# I used the Complex Slot Machine model described here:
# https://edspi31415.blogspot.com/2014/01/probability-odds-of-winning-at-slot.html
SlotSymbols1 = ([:BAR] + [:SEVEN] * 3 + [:CHERRY] * 4 + [:ORANGE] * 5 + [:BANANA] * 5 + [:LEMON] * 5).shuffle
SlotSymbols2 = ([:BAR] + [:SEVEN] + [:CHERRY] * 3 + [:ORANGE] * 6 + [:BANANA] * 6 + [:LEMON] * 6).shuffle
SlotSymbols3 = SlotSymbols2.shuffle
CherryReward3 = 20
CherryReward2 = 4
CherryReward1 = 1
BarReward     = 500 #  60
SevenReward   = 250 # 40
FruitReward   = 10
def slot_reward(slot_arr)
  cherry_count = slot_arr.count(:CHERRY)
  if cherry_count == 3
    return CherryReward3
  elsif cherry_count == 2
    return CherryReward2
  elsif cherry_count == 1
    return CherryReward1
  elsif slot_arr.all? { |x| x == :BAR }
    return BarReward
  elsif slot_arr.all? { |x| x == :SEVEN }
    return SevenReward
  elsif slot_arr.all? { |x| x == :ORANGE || x == :LEMON || x == :BANANA }
    return FruitReward
  else
    return 0 # sorry nothing
  end
end

def ellipses(seconds=0.5, n=3)
  (1..n).each do |i|
    sleep(seconds)
    print('.')
  end
  sleep(seconds)
end


def slot_machine(actor)

  reward_multiplier = 1
  
  if actor.wallet.money < 5 
    puts "Too broke to try the slots"
    return
  end

  actor.wallet.withdraw(5)


  results = [SlotSymbols1.sample, SlotSymbols2.sample, SlotSymbols3.sample]
  reward = slot_reward(results)
  ellipses 0.33
  print(results[0])
  ellipses 0.66
  print(results[1])
  ellipses 0.70
  print("#{results[2]}\n")
  if reward == 0
    puts "SORRY NOTHING"
    return "SORRY NOTHING"
  else
    actor.wallet.deposit(reward_multiplier * reward)
    puts "YOU WON $#{reward_multiplier * reward}"
  end
end

IntroText = "WELCOME TO SYRUP HEARTS CASINO!"

MenuText = "1 - Higher Or Lower
2 - Coin Slots
3 - Leave"


def game_loop
  player = make_actor
  puts "Starting game as #{player.name.upcase}"
  puts "\n." * 3
  puts IntroText

  while player.wallet.money > 0
    puts "You have #{player.wallet}"
    option = prompt(MenuText)

    #For now we will assume the input is valid.

    case option
    when "1"
      high_or_low player
    when "2"
      slot_machine player
    when "3"
      exit
    else
      puts "Invalid Option"
    end
  end
end
