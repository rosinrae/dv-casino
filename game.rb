
require_relative 'actor'
require_relative 'deck'
require_relative 'interactive'

LowestCard = Card.new(3, :SPADES)
HighestCard = Card.new(11, :SPADES)
HigherOrLowerRounds = 8

# Makes sure the input received is between min & max

def validate_wager(text, min, max)
  prompt_text = "#{text}? Min: $#{min}, Max: $#{max}"
  while true
    wager = prompt(prompt_text).to_i
    if min <= wager and wager <= max
      return wager
    else
      puts "Invalid wager"
    end
  end
end

def compare_opts(op, input)
  op.upcase == input.upcase
end

# If default_op1 is true, then any input other than op2 will return true
# otherwise, method is guaranteed to return
# true iff user inputs op1
# false iff user inputs op2
def binary_option(text, op1, op2, default_op1=true)
  prompt_text = "#{text}? #{op1}/#{op2}#{default_op1 ? " - (default: #{op1})": nil}"

  if default_op1
    input = prompt(prompt_text)
    return !compare_opts(op2, input) # False if input == op2, otherwise True
  else
    while true
      input = prompt(prompt_text)
      if compare_opts(op1, input) # True if op1
        return true
      elsif compare_opts(op2, input) # False if op2
        return false
      else
        puts "Invalid option" # Don't let us stop until we have a valid option
      end
    end
  end
end

# HIGH OR LOW
# use cards from 3 to Jack
# get an initial pool up to player's money
# make wagers from there, minimum half of the pool
# if player guesses correctly, add wager to pool
# if player guesses incorrectly, take wager from the pool
# go for 8 rounds or until the pool is empty

def high_or_low(actor)
  pool = validate_wager("Initial Pool", 1, actor.wallet.money)
  actor.wallet.withdraw pool
  deck = Deck.new()
  # Clear out any cards that are too high or low to play with
  deck.deck.reject! { |card| card < LowestCard ||
                             card > HighestCard }

  # Ugly spaghetti code
  # "Better to have it done and ugly"
  for i in (1..HigherOrLowerRounds)
    wager = validate_wager("Wager", pool/2, pool)

    cur_card = deck.draw
    next_card = deck.draw
    guess_high = binary_option("Card is #{cur_card}\nnext is higher or lower", "H", "L")
    puts "Next card is #{next_card}"

    #handle winning conditions first
    if next_card < cur_card && !guess_high || next_card > cur_card && guess_high
      puts "Correct!"
      pool += wager
    else
      puts "Incorrect!"
      pool -= wager
      
      if pool == 0
        puts "Pool is empty! Sorry!"
        break
      end

    end
  end
  actor.wallet.deposit pool
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

SlotCost = 5

def slot_machine(actor)

  reward_multiplier = 1
  playing = true
  
  while actor.wallet.money >= SlotCost and playing
    actor.wallet.withdraw(SlotCost)

    results = [SlotSymbols1.sample, SlotSymbols2.sample, SlotSymbols3.sample]
    reward = slot_reward(results)

    ellipses 0.33
    print(results[0])
    ellipses 0.66
    print(results[1])
    ellipses 0.70
    puts(results[2])

    if reward == 0
      puts "SORRY NOTHING"
    else
      actor.wallet.deposit(reward_multiplier * reward)
      puts "YOU WON $#{reward_multiplier * reward}"
    end
  playing = binary_option("Play again", "Y", "N")
  end
end

IntroText = "WELCOME TO SYRUP HEARTS CASINO!"

MenuText = "1 - Higher Or Lower
2 - Coin Slots
3 - Leave"


def game_loop
  player = make_actor
  puts "Starting game as #{player.name.upcase}"
  puts ".\n.\n."
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
  puts "You're out of money, bye!"
end
