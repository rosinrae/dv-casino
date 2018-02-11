class Actor

  attr_accessor :name, :bankroll

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def to_s
    "#{@name} - $#{@bankroll}"
  end

end

Names = [ "bill", "bob", "benjamin", "jenny", "phil", "kelly", "kirsten", "annie", "rachel", "vinny" ]

LowRollerAmount = 100.00
MidRollerAmount = 1000.00
HighRollerAmount = 100000.00
LowRollerWeight = 70
MidRollerWeight = 25
HighRollerWeight = 5
def make_player
  name = Names.sample
  roller_decision = rand(100)
  roller_value = roller_decision < LowRollerWeight ? LowRollerAmount :
    roller_decision < LowRollerWeight + MidRollerWeight ? MidRollerAmount : HighRollerAmount
  Actor.new(name, roller_value)
end
