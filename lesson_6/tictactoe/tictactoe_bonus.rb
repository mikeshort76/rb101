WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

ROUNDS_PER_GAME = 5

STARTING_PLAYER = 'choose'

scores = {
  player: 0,
  computer: 0
}

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "First player to #{ROUNDS_PER_GAME} is the Grand Champion!"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def joinor(arr, delimiter=", ", joining_word='or')
  str = arr.size == 2 ? arr.join(' ') : arr.join(delimiter)
  str[-1] = str[-1].prepend(joining_word + ' ') unless str.size == 1
  str
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def critical_square(brd)
  square = find_critical_square(brd, COMPUTER_MARKER) # offensive
  square ||= find_critical_square(brd, PLAYER_MARKER) # defensive
  square
end

def find_critical_square_in_line(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2
    brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def find_critical_square(brd, marker)
  square = nil
  WINNING_LINES.each do |line|
    square = find_critical_square_in_line(line, brd, marker)
    break if square
  end
  square
end

def computer_places_piece!(brd)
  square = critical_square(brd)
  square ||= empty_squares(brd).include?(5) ? 5 : empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, current_player)
  if current_player == 'player'
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def choose_starting_player
  starter = STARTING_PLAYER
  if STARTING_PLAYER == 'choose'
    system 'clear'
    loop do
      prompt "Who goes first? (enter 'c' for computer, 'p' for player)"
      choice = gets.chomp
      starter = 'computer' if choice == 'c'
      starter = 'player' if choice == 'p'
      break if starter == 'computer' || starter == 'player'
      prompt "That is an invalid choice. Please reselect."
    end
  end
  starter
end

def alternate_player(current_player)
  current_player == 'player' ? 'computer' : 'player'
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'computer'
    end
  end
  nil
end

def increment_score(winner, scores)
  if winner == 'player'
    scores[:player] += 1
  elsif winner == 'computer'
    scores[:computer] += 1
  end
end

def display_score(scores)
  prompt "Player: #{scores[:player]}, Computer: #{scores[:computer]}"
end

def identify_grand_champion(scores)
  if scores[:player] == ROUNDS_PER_GAME
    prompt 'Player is the Grand Champion!'
  elsif scores[:computer] == ROUNDS_PER_GAME
    prompt 'Computer is the Grand Champion!'
  else
    false
  end
end

def play_again?
  answer = ''
  loop do
    prompt "Play again? (y or n)"
    answer = gets.chomp
    if answer != 'y' && answer != 'n'
      prompt "Sorry, that's not a valid choice."
    else
      break
    end
  end
  system 'clear'
  answer == 'y'
end

loop do
  board = initialize_board
  current_player = choose_starting_player

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  increment_score(detect_winner(board), scores)

  display_score(scores)

  break if identify_grand_champion(scores)

  break unless play_again?
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
