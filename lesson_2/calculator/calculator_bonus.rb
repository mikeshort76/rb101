# ---------YAML MODULE-----------

require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

# ---------CONSTANTS-----------

LANGUAGE = {
  '1' => 'en',
  '2' => 'fr',
  '3' => 'sp'
}

# ---------METHODS-----------

def message(message_key, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(message_key, lang = 'en')
  Kernel.puts("=> #{MESSAGES[lang][message_key]}")
end

def integer?(num)
  num.to_i.to_s == num
end

def float?(num)
  num.to_f.to_s == num
end

def number?(input)
  integer?(input) || float?(input)
end

operation = ''
def operation_to_message(op)
  operation = case op
  when '1'
    'Adding'
  when '2'
    'Subtracting'
  when '3'
    'Multiplying'
  when '4'
    'Dividing'
  end
  operation
end

# ---------MAIN PROGRAM-----------

prompt('welcome')

name = ''
loop do
  name = Kernel.gets().chomp()

  if name.empty?()
    prompt('valid_name')
  else
    break
  end
end

puts format(MESSAGES['en']['greeting'], name: name)

loop do 
  number1 = ''
  loop do
    prompt('first_number')
    number1 = Kernel.gets().chomp()

    if number?(number1)
      break
    else
      prompt('invalid_number')
    end
  end

  number2 = ''
  loop do
    prompt('second_number')
    number2 = Kernel.gets().chomp()

    if number?(number2)
      break
    else
      prompt('invalid_number')
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG

  puts operator_prompt

  operator = ''
  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt('choose_operator')
    end
  end

  result = case operator
           when '1'
             number1.to_f() + number2.to_f()
           when '2'
             number1.to_f() - number2.to_f()
           when '3'
             number1.to_f() * number2.to_f()
           when '4'
             number1.to_f() / number2.to_f()
           end

  puts format(MESSAGES['en']['result'], result: result)

  prompt('another_calculation')
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt('goodbye')
