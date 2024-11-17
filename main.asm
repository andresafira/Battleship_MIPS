.data
ships_quant: .space 24
ships_size: .space 20

board1: .space 1600
board2: .space 1600

equals_str: .asciiz "=============================================\n"
space_str: .asciiz " "
first_vertical_delimiter: .asciiz "|| "
last_vertical_delimiter: .asciiz "||\n"
newline: .asciiz "\n"
wrong_shot_sign: .asciiz "X"
correct_shot_sign: .asciiz "O"
row_input: .asciiz "\nRow to input the ship: "
column_input: .asciiz "Column to input the ship: "
direction_input: .asciiz "Layout of the ship (0: vertical, 1: horizontal):"
ship_input: .asciiz "Choose the ship (0: carrier, 1: cruiser, 2: destroyer, 3: submarine, 4: patrol):"
invalid_position: .asciiz "===== Invalid Position ====="
invalid_ship: .asciiz "===== Lack of specified ship ====="

.text

la $s0, ships_size

li $t0, 5
sw $t0, 0($s0)
li $t0, 4
sw $t0, 4($s0)
li $t0, 3
sw $t0, 8($s0)
li $t0, 3
sw $t0, 12($s0)
li $t0, 2
sw $t0, 16($s0)

la $a0, board1
jal SHIPPING_PROCESS

j MAIN_END
########### Functions ###########

INIT_SHIPS_QUANT:   # ok!
# $a0 : vector_address
addi $sp, $sp, -4
sw $s0, 0($sp)

li $s0, 1
sw $s0, 0($a0)
sw $s0, 4($a0)
li $s0, 2
sw $s0, 8($a0)
sw $s0, 12($a0)
sw $s0, 16($a0)
li $s0, 8
sw $s0, 20($a0)

lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra
#####################

GET_POS_ADDRESS:   # ok!
# $a0 : i
# $a1 : j
addi $sp, $sp, -12

sw $t0, 0($sp)
sw $t1, 4($sp)
sw $ra, 8($sp)

sll $t0, $a0, 4
sll $t1, $a0, 2
add $t0, $t0, $t1
add $t0, $t0, $a1 # $t0 = 20*i + j
sll $v0, $t0, 2

lw $t0, 0($sp)
lw $t1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12

jr $ra
#####################

GET_POS:      # ok!
# $a0 : i
# $a1 : j
# $a2 : board_address
addi $sp, $sp, -4
sw $ra, 0($sp)

jal GET_POS_ADDRESS
add $v0, $v0, $a2
lw $v0, 0($v0)

lw $ra, 0($sp)
addi $sp, $sp, 4

jr $ra
#####################

PUT_POS:     # ok!
# $a0 : i
# $a1 : j
# $a2 : board_address
# $a3 : value
addi $sp, $sp, -4
sw $ra, 0($sp)

jal GET_POS_ADDRESS
add $v0, $v0, $a2
sw $a3, 0($v0)

lw $ra, 0($sp)
addi $sp, $sp, 4

jr $ra
#####################

IS_VALID:    # ok!
# $a0 : i
# $a1 : j

blt $a0, 0, FALSE_IS_VALID
blt $a1, 0, FALSE_IS_VALID
bge $a0, 20, FALSE_IS_VALID
bge $a1, 20, FALSE_IS_VALID

li $v0, 1
jr $ra

FALSE_IS_VALID:
li $v0, 0
jr $ra
#####################

INIT_BOARD:    # ok!
# $a0 : board_address
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

li $s0, 0
LOOP_INIT_BOARD:
beq $s0, 1600, EXIT_LOOP_INIT_BOARD
add $s1, $a0, $s0
sw $zero, 0($s1)
addi $s0, $s0, 4
j LOOP_INIT_BOARD
EXIT_LOOP_INIT_BOARD:

lw $s0, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8

jr $ra
#####################

SHIP_IS_VALID:    # ok!
# $a0 : i
# $a1 : j
# $a2 : board_address
# $a3 : size
# $v1 : horizontal
addi $sp, $sp, -12

sw $t0, 0($sp)
sw $t1, 4($sp)
sw $ra, 8($sp)

li $t0, 0   # $t0 : iterator of the for loop
li $t1, 1   # $t1 : valid boolean
# SIV : Ship Is Valid
LOOP_SIV:
beq $t0, $a3, LOOP_SIV_EXIT
jal IS_VALID
and $t1, $t1, $v0         # valid = valid && is_valid(i, j)

beq $t1, 0, IF_SIV_GETPOS_EXIT  # if not valid
jal GET_POS               
beq $v0, 0, IF_SIV_GETPOS # if the position is valid
li $t1, 0
j IF_SIV_GETPOS_EXIT
IF_SIV_GETPOS:
li $t1, 1
IF_SIV_GETPOS_EXIT:

beq $v1, 0, VERTICAL_SIV  # check if it is horizontal or not
addi $a1, $a1, 1          # j ++ (horizontal)
j VERTICAL_SIV_EXIT
VERTICAL_SIV:
addi $a0, $a0, 1          # i ++ (vertical)
VERTICAL_SIV_EXIT:

addi $t0, $t0, 1
j LOOP_SIV
LOOP_SIV_EXIT:
addi $v0, $t1, 0

lw $t0, 0($sp)
lw $t1, 4($sp)
lw $ra, 8($sp)

addi $sp, $sp, 12
jr $ra
#####################

PRINT_BOARD:     # ok!
# $a0 : board
# $a1 : shipping

addi $sp, $sp, -32
sw $ra, 0($sp)
sw $t0, 4($sp)
sw $t1, 8($sp)
sw $t2, 12($sp)
sw $t3, 16($sp)
sw $t4, 20($sp)
sw $t5, 24($sp)
sw $t9, 28($sp)

move $a2, $a0  # $a2 = board
move $t9, $a1  # $t9 = shipping

li $v0, 4   # code for print syscall
la $a0, equals_str
syscall

li $t0, 0  # iterator (i)
LOOP_I_PB:
beq $t0, 20, LOOP_I_PB_EXIT
la $a0, first_vertical_delimiter
li $v0, 4   # code for print syscall
syscall

li $t1, 0  # iterator (j)
LOOP_J_PB:
beq $t1, 20, LOOP_J_PB_EXIT
move $a0, $t0
move $a1, $t1
jal GET_POS
move $t2, $v0 # t2 = value

seq $t3, $t2, 0   # t3 = (value == 0)
seq $t4, $t2, 1   # t4 = (value == 1)
not $t5, $t9      # t5 = !shipping
and $t5, $t4, $t5 # t5 = (value == 1 && !shipping)
or $t5, $t5, $t3  # t5 = (value == 0 || value == 1 && !shipping)

li $v0, 4   # code for print syscall
beq $t5, 0, IF_O_PB
la $a0, space_str
syscall
j IF_PB_EXIT

IF_O_PB:          # Case where the player shot a ship
seq $t3, $t2, 3   # t3 = (value == 3)
or $t3, $t3, $t4  # t3 = (value == 3 || value == 1)
beq $t3, 0, IF_X_PB

la $a0, correct_shot_sign
syscall
j IF_PB_EXIT

IF_X_PB:         # Case where the player shot an empty tile
seq $t3, $t2, 2  # t3 = (value == 2)
beq $t3, 0, IF_PB_EXIT

la $a0, wrong_shot_sign
syscall

IF_PB_EXIT:
la $a0, space_str
syscall

addi $t1, $t1, 1
j LOOP_J_PB
LOOP_J_PB_EXIT:

la $a0, last_vertical_delimiter
syscall

addi $t0, $t0, 1
j LOOP_I_PB
LOOP_I_PB_EXIT:

la $a0, equals_str
syscall

lw $ra, 0($sp)
lw $t0, 4($sp)
lw $t1, 8($sp)
lw $t2, 12($sp)
lw $t3, 16($sp)
lw $t4, 20($sp)
lw $t5, 24($sp)
lw $t9, 28($sp)

addi $sp, $sp, 32

jr $ra
#####################

INPUT_SHIP:    # ok!
# $a0 : i
# $a1 : j
# $a2 : board_address
# $a3 : size
# $v1 : horizontal
addi $sp, $sp, -12
sw $ra, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)

move $t9, $a3
li $a3, 1
li $t0, 0 # iterator (i)
LOOP_IS:
beq $t0, $t9, LOOP_IS_EXIT
jal PUT_POS

beq $v1, 0, VERTICAL_IS
addi $a1, $a1, 1
j VERTICAL_IS_EXIT

VERTICAL_IS:
addi $a0, $a0, 1

VERTICAL_IS_EXIT:
addi $t0, $t0, 1
j LOOP_IS

LOOP_IS_EXIT:
lw $ra, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
addi $sp, $sp, 12

jr $ra

SHIPPING_PROCESS:
# $a0 : board_address

addi $sp, $sp, -48

sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $t0, 16($sp)
sw $t1, 20($sp)
sw $t2, 24($sp)
sw $t3, 28($sp)
sw $t4, 32($sp)
sw $t5, 36($sp)
sw $t6, 40($sp)
sw $t9, 44($sp)

move $s0, $a0 # s0 = board_address
la $a0, ships_quant
jal INIT_SHIPS_QUANT
lw $t9, 20($a0)    # t9 = total number of ships remaining
move $s1, $a0      # s1 = ships_quant_address
la $s2, ships_size # s2 = ships_size_address

WHILE_SHIPPING:
beq $t9, 0, WHILE_SHIPPING_EXIT

USER_INPUT_SP:
li $v0, 4 # print row input sentence
la $a0, row_input
syscall

li $v0, 5 # get row input and store in $t0
syscall
move $t0, $v0

li $v0, 4 # print column input sentence
la $a0, column_input
syscall

li $v0, 5 # get column input and store in $t1
syscall
move $t1, $v0

li $v0, 4 # print direction input sentence
la $a0, direction_input
syscall

li $v0, 5 # get direction input and store in $t2
syscall
move $t2, $v0

SHIP_USER_INPUT_SP:
li $v0, 4 # print ship input sentence
la $a0, ship_input
syscall

li $v0, 5 # get ship input and store in $t3
syscall
bgt $v0, 4, SHIP_USER_INPUT_SP
blt $v0, 0, SHIP_USER_INPUT_SP
SHIP_USER_INPUT_SP_EXIT:
sll $t3, $v0, 2 # store the ship value times 4

move $a0, $t0  # a0 = i
move $a1, $t1  # a1 = j
move $a2, $s0  # a2 = board address
add $a3, $t3, $s2
lw $a3, 0($a3) # a3 = size of specified ship
move $v1, $t2  # v1 = direction

jal SHIP_IS_VALID
move $t4, $v0  # t4 = valid_position

beq $t4, 0, INVALID_POSITION_SP
add $t5, $t3, $s1
lw $t6, 0($t5)  # t6 = ships_quant[ship]
beq $t6, 0, LACK_SHIP_SP

j USER_INPUT_SP_EXIT

INVALID_POSITION_SP:
li $v0, 4
la $a0, invalid_position
syscall
j USER_INPUT_SP

LACK_SHIP_SP:
li $v0, 4
la $a0, invalid_ship
syscall
j USER_INPUT_SP

USER_INPUT_SP_EXIT:

addi $t6, $t6, -1
sw $t6, 0($t5)   # ships_quant[ship] --
addi $t9, $t9, -1  # ships_quant[5] --

move $a0, $t0  # a0 = i

jal INPUT_SHIP

move $a0, $s0
li $a1, 1
jal PRINT_BOARD

j WHILE_SHIPPING
WHILE_SHIPPING_EXIT:

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $t0, 16($sp)
lw $t1, 20($sp)
lw $t2, 24($sp)
lw $t3, 28($sp)
lw $t4, 32($sp)
lw $t5, 36($sp)
lw $t6, 40($sp)
lw $t9, 44($sp)

addi $sp, $sp, 48

jr $ra

########## Program End ##########
MAIN_END:
