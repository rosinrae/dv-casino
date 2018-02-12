

class Library
  class Error < RuntimeError
  end

  class WalletError < Error
  end

  class DeckError < Error
  end
end
