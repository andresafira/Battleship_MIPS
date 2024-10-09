.data
player1_board: .space 1600    # Alocando 1600 bytes para o tabuleiro do jogador 1
player2_board: .space 1600    # Alocando 1600 bytes para o tabuleiro do jogador 2

.text

.globl main
main:
    # Inicializar o tabuleiro dos dois jogadores com 0 (representando vazio)
    
    li $t0, 0            # Valor 0 (espaço vazio)
    la $t1, player1_board # Endereço inicial do tabuleiro do jogador 1
    la $t2, player2_board # Endereço inicial do tabuleiro do jogador 2
    li $t3, 400          # Tamanho da matriz (20x20 = 400 células)

init_boards:
    beq $t3, $zero, end_init   # Se $t3 for 0, termine a inicialização
    sw $t0, 0($t1)             # Armazene 0 (4 bytes) na posição atual da matriz do jogador 1
    sw $t0, 0($t2)             # Armazene 0 (4 bytes) na posição atual da matriz do jogador 2
    addi $t1, $t1, 4           # Próxima posição na matriz do jogador 1 (4 bytes por célula)
    addi $t2, $t2, 4           # Próxima posição na matriz do jogador 2 (4 bytes por célula)
    addi $t3, $t3, -1          # Decrementa o contador de posições
    j init_boards              # Repete até inicializar todas as posições

end_init:
    # Imprimir o tabuleiro no terminal
    jal print_board            # Chama a função para imprimir o tabuleiro

    # Exemplo de fim de programa
    li $v0, 10                 # Código para sair do programa
    syscall

# Função para imprimir o tabuleiro no terminal
print_board:
    li $t0, 0                # Índice da matriz (posição atual)
    la $t1, player1_board     # Endereço inicial do tabuleiro do jogador 1

print_row:
    li $t2, 20               # Número de colunas (20 por linha)

print_cell:
    beq $t2, $zero, print_newline  # Se terminou a linha, vai para nova linha
    lw $t3, 0($t1)           # Carrega o valor da célula atual (4 bytes)
    move $a0, $t3            # Move o valor para o registrador $a0 (para syscall de impressão)
    li $v0, 1                # Syscall de impressão de inteiro
    syscall                  # Imprime a célula

    # Espaço após cada célula
    li $a0, 32               # ASCII para espaço (' ')
    li $v0, 11               # Syscall de impressão de caractere
    syscall

    addi $t1, $t1, 4         # Próxima célula (4 bytes por célula)
    addi $t0, $t0, 1         # Incrementa o índice
    addi $t2, $t2, -1        # Decrementa o contador de colunas
    j print_cell             # Repete para a próxima célula

print_newline:
    # Adiciona uma nova linha
    li $a0, 10               # ASCII para newline ('\n')
    li $v0, 11               # Syscall de impressão de caractere
    syscall

    # Verifica se terminou o tabuleiro (400 células)
    li $t4, 400
    bge $t0, $t4, end_print  # Se $t0 >= 400, terminou de imprimir

    j print_row              # Volta para imprimir a próxima linha

end_print:
    jr $ra                   # Retorna da função