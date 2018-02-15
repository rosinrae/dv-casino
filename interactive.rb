PromptText = "$>"

def prompt(prompt_text="")
  unless prompt_text.empty?
    puts prompt_text
  end
  print PromptText
  gets.strip
end
