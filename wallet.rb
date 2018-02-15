require_relative "exception"

class Wallet

  attr_reader :money

  def initialize(money)
    @money = money
  end

  def to_s
    "$#{@money}"
  end

  def withdraw(amount)
    if amount > @money
      raise Library.WalletError
    else
      @money -= amount
      return amount
    end
  end

  def deposit(amount)
    @money += amount
  end
end
