##############################################################################
#
#  KURS: 1DT093 2023.  Computer Architecture
#	
# DATUM: 2026-11-13
#
#  NAMN: Hannes Eriksson			
#
#  NAMN: Tomas Rosander
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "Hunden, Katten, Glassen"

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
	beq $t0, $a1, end_for_all # Done if i == N
	sll $t1, $t0, 2 # 4*i
	add $t2, $a0, $t1 # address = ARRAY + 4*i
	lw $t3, 0($t2) # n = A[i]
       	add $v0, $v0, $t3 # Sum = Sum + n
        addi $t0, $t0, 1 # i++ 
  	j for_all_in_array # next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####
	
	add $t0, $0, $0 # Set index i to ero
	add $v0, $0, $0 # Set length to zero
	
string_inspector:	
	
	lbu $t1, 0($a0) # Loads thee character from the string
	beq $t1, $0, string_counter # Done when the whole string has been counted
	
	addi $t0, $t0, 1 # Move index i up one step
	addi $a0, $a0, 1 # Move the adress up one step
	
	j string_inspector
	
string_counter:
	add $v0, $t0, $0 # Set $v0 to the value of index i

	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:
	
	addi	$sp, $sp, -4		# PUSH return address to caller
	sw	$ra, 0($sp)	# Store return adress

	#### Write your solution here ####
	# PUSH $s0 and $s1
	addi	$sp, $sp, -8
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	
	# Keep arguments intact by saving to $s
	add	$s0, $a0, $zero
	add	$s1, $a1, $zero
	
	for_each_char:		# The loop for each char
		lb	$t0, 0($s0)	# load current char
		beq	$t0, $zero, end_for_each	# if char == null
		add	$a0, $s0, $zero		# argument = adress of current char
		jalr	$s1		# calls callback with argument $a0
		addi	$s0, $s0, 1		# goes to next char
		j for_each_char
		
	end_for_each:
		# Load the $s varibles back
		lw	$s1, 0($sp)
		lw	$s0, 4($sp)
		addi	$sp, $sp, 8
	
	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4		

	jr	$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
	lb 	$t0, 0($a0)		# $t0 = byte stored in adress $a0
	blt	$t0, 'a', end_upper	# leave unchanged (ascii code for 'a')
	bgt	$t0, 'z', end_upper	# leave unchanged (ascii code for 'z')
	addi 	$t0, $t0, -32		# shift ascii code to lower case	
	sb	$t0, 0($a0)		# Store character back into string
    
end_upper:

	jr	$ra


##############################################################################
#
#  DESCRIPTION: When given a string such as “ABC” as input it should produce “CBA” as the output.
#	
#        INPUT: $a0 - address of a character 
#	 
##############################################################################

reverse_string:
	
	addi $sp, $sp, -8 # Make space for 2 words on the stack
	sw $ra, 4($sp) # Save the return adress on the stack
	sw $a0, 0($sp) # saves the first charcter on the stack
	
	jal string_length # Calls the string_length which returns $v0
	
	lw $ra, 4($sp) # Loads from the stack
	lw $a0, 0($sp)
	addi $sp, $sp, 8 # Returns space to the stack
	
	add $t0, $a0, $v0 # Add the start and the length which the points to the word after the last char
	
	addi $t0, $t0, -1 # Points to the last char
	
loop:
	bge $a0, $t0, end # if the start is eiher larger or the same as the end stop
	
	lbu $t1, 0($a0) # Loads the char from $a0 to $t1
	lbu $t2, 0($t0)# same as above
	
	sb $t1, 0($t0) # Switches the char between the first and the last char
	sb $t2, 0($a0)
	
	addi $t0, $t0, -1 # Moves the index down one step
	addi $a0, $a0, 1 # Moves the index up one step
	
	j loop # Jumps to the beginneing of the loop
	
	
	
end:
	jr $ra
	

##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	
	
STR_reverse_string:
	.asciiz "\n\nreverse_string(str)\n\n"

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string
	
	##
	### reverse_string(str)
	##

	li	$v0, 4
	la	$a0, STR_reverse_string
	syscall

	la	$a0, STR_str
	jal	reverse_string

	la	$a0, STR_str
	jal	print_test_string
	
	
	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	li $v0, 10	# Systemcall code exit
	syscall

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	
