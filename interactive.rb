PromptText = "$>"

def prompt(prompt_text="")
  unless prompt_text.empty?
    puts prompt_text
  end
  print PromptText
  gets.strip
end

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

