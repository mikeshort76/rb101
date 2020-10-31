def prompt(message)
  puts "=> #{message}"
end

def clear_screen()
  system('clear')
end

clear_screen()

loop do

prompt("Welcome to Mike's Loan Calculator")

loan_amount = ''
loop do
prompt("Enter loan amount:")
loan_amount = gets.chomp
if loan_amount.to_f.to_s == loan_amount || loan_amount.to_i.to_s == loan_amount && loan_amount.to_f > 0
  break
else
  prompt("Must enter positive number.")
end
end

apr = ''
loop do
prompt("Enter APR:")
prompt("(Example: 5 for 5% or 2.5 for 2.5%)")
apr = gets.chomp
if apr.to_f.to_s == apr || apr.to_i.to_s == apr && apr.to_f > 0
  break
else
  prompt("Must enter positive number.")
end
end

annual_loan_duration = ''
loop do
prompt("Enter duration (in years)")
annual_loan_duration = gets.chomp
if annual_loan_duration.to_f.to_s == annual_loan_duration || annual_loan_duration.to_i.to_s == annual_loan_duration && annual_loan_duration.to_f > 0
  break
else
  prompt("Must enter positive number.")
end
end

monthly_loan_duration = annual_loan_duration.to_i * 12
annual_interest_rate = apr.to_f / 100
monthly_int_rate = annual_interest_rate / 12
monthly_payment = loan_amount.to_f * (monthly_int_rate / (1 - (1 + monthly_int_rate)**(-monthly_loan_duration)))

prompt("Your monthly interest rate will be #{monthly_int_rate}%")
prompt("Your loan duration will be #{monthly_loan_duration} months")
prompt("Your monthly payment will be $#{format("%#.2f", monthly_payment)}")

prompt("Would you like to perform another loan calculation?")

answer = gets.chomp
break unless answer.downcase.start_with?('y')

end

prompt("Thanks for using Loan Calculator. Good bye!")