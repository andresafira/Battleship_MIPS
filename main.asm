.data
player1_board: .space 1600    # Alocando 1600 bytes para o tabuleiro do jogador 1
player2_board: .space 1600    # Alocando 1600 bytes para o tabuleiro do jogador 2

.text

.globl main
main:
    # Inicializar o tabuleiro dos dois jogadores com 0 (representando vazio)
    
    li $t0, 0            # Valor 0 (espa�o vazio)
    la $t1, player1_board # Endere�o inicial do tabuleiro do jogador 1
    la $t2, player2_board # Endere�o inicial do tabuleiro do jogador 2
    li $t3, 400          # Tamanho da matriz (20x20 = 400 c�lulas)

init_boards:
    beq $t3, $zero, end_init   # Se $t3 for 0, termine a inicializa��o
    sw $t0, 0($t1)             # Armazene 0 (4 bytes) na posi��o atual da matriz do jogador 1
    sw $t0, 0($t2)             # Armazene 0 (4 bytes) na posi��o atual da matriz do jogador 2
    addi $t1, $t1, 4           # Pr�xima posi��o na matriz do jogador 1 (4 bytes por c�lula)
    addi $t2, $t2, 4           # Pr�xima posi��o na matriz do jogador 2 (4 bytes por c�lula)
    addi $t3, $t3, -1          # Decrementa o contador de posi��es
    j init_boards              # Repete at� inicializar todas as posi��es

end_init:
    # Imprimir o tabuleiro no terminal
    jal print_board            # Chama a fun��o para imprimir o tabuleiro

    # Exemplo de fim de programa
    li $v0, 10                 # C�digo para sair do programa
    syscall

# Fun��o para imprimir o tabuleiro no terminal
print_board:
    li $t0, 0                # �ndice da matriz (posi��o atual)
    la $t1, player1_board     # Endere�o inicial do tabuleiro do jogador 1

print_row:
    li $t2, 20               # N�mero de colunas (20 por linha)

print_cell:
    beq $t2, $zero, print_newline  # Se terminou a linha, vai para nova linha
    lw $t3, 0($t1)           # Carrega o valor da c�lula atual (4 bytes)
    move $a0, $t3            # Move o valor para o registrador $a0 (para syscall de impress�o)
    li $v0, 1                # Syscall de impress�o de inteiro
    syscall                  # Imprime a c�lula

    # Espa�o ap�s cada c�lula
    li $a0, 32               # ASCII para espa�o (' ')
    li $v0, 11               # Syscall de impress�o de caractere
    syscall

    addi $t1, $t1, 4         # Pr�xima c�lula (4 bytes por c�lula)
    addi $t0, $t0, 1         # Incrementa o �ndice
    addi $t2, $t2, -1        # Decrementa o contador de colunas
    j print_cell             # Repete para a pr�xima c�lula

print_newline:
    # Adiciona uma nova linha
    li $a0, 10               # ASCII para newline ('\n')
    li $v0, 11               # Syscall de impress�o de caractere
    syscall

    # Verifica se terminou o tabuleiro (400 c�lulas)
    li $t4, 400
    bge $t0, $t4, end_print  # Se $t0 >= 400, terminou de imprimir

    j print_row              # Volta para imprimir a pr�xima linha

end_print:
    jr $ra                   # Retorna da fun��o