#include <stdio.h>

void init_ships_quant(int* ships_quant){
  ships_quant[0] = 1;
  ships_quant[1] = 1;
  ships_quant[2] = 2;
  ships_quant[3] = 2;
  ships_quant[4] = 2;
  ships_quant[5] = 8;
}

int get_pos(int* board, int i, int j){
  return board[20*i + j];
}

void put_pos(int* board, int i, int j, int val){
  board[20*i + j] = val;
}

int is_valid(int* board, int i, int j){
  return ((i >= 0 && i < 20) && (j >= 0 && j < 20));
}

int ship_is_valid(int* board, int i, int j, int size, int hor){
  int valid = 1;
  int a = i;
  int b = j;
  for (int d = 0; d < size; ++d){
    if (hor) {
      b += d;
    } else {
      a += d;
    }

    valid = valid & is_valid(board, a, b);
    if (valid) {
      valid = valid & (get_pos(board, a, b) == 0);
    } else {
      return 0;
    }
  }
  return valid;
}

void init_board(int* board){
  for (int i = 0; i < 400; ++i){
    board[i] = 0;
  }
}

void print_board(int* board){
  int value = 0;
  for (int i = 0; i < 45; ++i){
    printf("=");
  }
  printf("\n");
  for (int i = 0; i < 20; ++i){
    printf("|| ");
    for (int j = 0; j < 20; ++j){
      value = get_pos(board, i, j);
      if (value == 0){
        printf("  ");
      } else if (value == 1) {
        printf("O ");
      } else {
        printf("X ");
      }
    }
    printf("||\n");
  }
  for (int i = 0; i < 45; ++i){
    printf("=");
  }
}

void input_ship(int* board, int i, int j, int size, int horizontal){
  for (int d = 0; d < size; ++d) {
    if (horizontal) {
      put_pos(board, i, j + d, 1);
    } else {
      put_pos(board, i + d, j, 1);
    }
  }
}

void shipping(int* board, int* ships_size){
  int i, j, valid_position, ship, direction_horizontal;
  int ships_quant[6];

  init_ships_quant(ships_quant);

  while (ships_quant[5] > 0){
    do {
      printf("\nRow to input the ship: ");
      scanf("%d", &i);
      printf("Column to input the ship: ");
      scanf("%d", &j);
      printf("Layout of the ship: (0: vertical, 1: horizontal) -> ");
      scanf("%d", &direction_horizontal);
      printf("Choose the ship: (0: carrier, 1: cruiser, 2: destroyer, 3: submarine, 4: patrol) -> ");
      scanf("%d", &ship);
      
      valid_position = ship_is_valid(board, i, j, ships_size[ship], direction_horizontal);

      if (!valid_position) {
        printf("===== Invalid Position =====");
      } else if (ships_quant[ship] == 0) {
        valid_position = 0;
        printf("===== Lack of specified ship =====");
      } else {
        ships_quant[ship]--;
        ships_quant[5]--;
      }
    } while (!valid_position);

    input_ship(board, i, j, ships_size[ship], direction_horizontal);

    print_board(board);
  }
}

int main(){
  int board1[400];
  int board2[400];
  int ships_quant[6];
  int ships_size[5] = {5, 4, 3, 3, 2};

  init_ships_quant(ships_quant);
  init_board(board1);
  init_board(board2);
  
  shipping(board1, ships_size);
  printf("\nSwitch players now (use DC)\n");
  shipping(board2, ships_size);
  
  int turn = 0, win = 0, i, j, valid;
  int** current_board;
  current_board[0] = board2;
  current_board[1] = board1;

  while (!win) {
    do {
      printf("\nRow to shoot: ");
      scanf("%d", &i);
      printf("Column to shoot: ");
      scanf("%d", &j);

      valid = is_valid(current_board[turn], i, j);
      if (valid){
        valid = (get_pos(current_board[turn], i, j) != 2);
      }

      if (!valid) {
        printf("===== Invalid Position! =====");
      }
    } while (!valid);
    
    // Make logic for shooting the ships


    turn = !turn;
  }

  return 0;
}
