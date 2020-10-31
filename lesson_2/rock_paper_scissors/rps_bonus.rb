VALID_CHOICES = %w(rock paper scissors lizard Spock)
MAX_SCORE = 5

def clear_screen
  system('clear')
end

def valid_abbreviation
  abbreviations = []
  VALID_CHOICES.each do |choice|
    char_index = 0
    loop do
      if abbreviations.include?(choice.slice(char_index).downcase)
        char_index += 1
      else
        abbreviations << choice.slice(char_index).downcase
        break
      end
    end
  end
  abbreviations
end

def player_choice(choice)
  if VALID_CHOICES.include?(choice)
    choice
  elsif valid_abbreviation().include?(choice)
    VALID_CHOICES[valid_abbreviation().index(choice)]
  end
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def win?(first, second)
  moves = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'Spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['Spock', 'paper'],
    'Spock' => ['scissors', 'rock']
  }
  moves[first].include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def increment_score(scores, player, computer)
  if win?(player, computer)
    scores[:player] += 1
  elsif win?(computer, player)
    scores[:computer] += 1
  end
end

def display_winner(scores)
  if scores[:player] > scores[:computer]
    prompt("You won #{scores[:player]} to #{scores[:computer]}!")
  else
    prompt("You lost #{scores[:computer]} to #{scores[:player]}.")
  end
end

def play_again?
  answer = ''
  loop do
    prompt("Do you want to play again? ('y' or 'n')")
    answer = Kernel.gets().chomp()
    if answer.downcase == 'y'
      return true
    elsif answer.downcase == 'n'
      return false
    else
      prompt("Invalid response. Please reenter.")
    end
  end
end

loop do
  clear_screen()
  scores = {
    player: 0,
    computer: 0
  }
  prompt("Welcome to #{VALID_CHOICES.join(', ')}")
  prompt("Score 5 points before the computer to win!")
  loop do
    choice = ''
    loop do
      selection_prompt = <<-MSG

        CHOOSE ONE: #{VALID_CHOICES.join(', ')}
                    (shortcuts: #{valid_abbreviation().join(', ')})
      MSG

      puts selection_prompt

      choice = Kernel.gets().chomp().downcase

      if VALID_CHOICES.include?(choice) || valid_abbreviation().include?(choice)
        choice = player_choice(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.sample

    prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

    display_results(choice, computer_choice)

    increment_score(scores, choice, computer_choice)

    prompt("You: #{scores[:player]}")
    prompt("Computer: #{scores[:computer]}")

    break if scores[:player] == MAX_SCORE || scores[:computer] == MAX_SCORE
  end

  display_winner(scores)

  break unless play_again?
end

prompt('Thank you for playing. Good bye!')
