.data
ships_quant: .space 24

board1: .space 1600
board2: .space 1600

.text

la $a0, ships_quant
li $s0, 317
jal INIT_SHIPS_QUANT

j MAIN_END
########### Functions ###########

INIT_SHIPS_QUANT:
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

GET_POS_ADDRESS:
# $a0 : i
# $a1 : j
addi $sp, $sp, -12

sw $t0, 0($sp)
sw $t1, 4($sp)
sw $ra, 8($sp)

sll $t0, $a0, 4
sll $t1, $a0, 2
add $a0, $t0, $t1
add $a0, $a0, $a1 # $a1 = 20*i + j
sll $v0, $a0, 2

lw $t0, 0($sp)
lw $t1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12

jr $ra
#####################

GET_POS:
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

PUT_POS:
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

IS_VALID:
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

INIT_BOARD:
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

########## Program End ##########
MAIN_END:
