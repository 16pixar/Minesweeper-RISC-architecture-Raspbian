# Minesweeper RISC-architecture on Raspbian OS

  To develop this program, you must use assembly language for RISC architectures via Raspbian OS. This can be achieved through two methods: directly on a Raspberry Pi device or using the QEMU emulator; both options are acceptable. This specific compiler must be used despite the existence of other alternatives. You cannot use C or C++ functions directly in the program code. To execute higher-level functions, you must only use system call services.


# Minesweeper Implementation Guidelines
## Implementation

1. The program must be executed in a command-line interface, devoid of any graphical elements or user interactions beyond keyboard inputs and on-screen printing.

2. As per the regulations, the game should allow for the adjustment of width, height, and the quantity of mines in the field before initiation. Users should be able to choose between three predefined modes or opt for a custom setup, adhering to the following constraints: a maximum size of 100 in any direction and a mines count not exceeding 50% of the available fields.

3. At all times, the following information must be displayed:
   - Current configuration of the game field including revealed fields, numbered fields, and flagged marks.
   - Current game state indicating the number of remaining mines to be marked and other pertinent statistics related to the game field.
  
# Abstraction of the Rules

To play Minesweeper, the following rules must be considered:

- Clicking reveals all non-bomb squares (for project purposes, this occurs when indicating the space in the grid).
- There are 8 different types of square representations: Bomb, Empty square, Undiscovered square, Flag, Question mark, and numbers indicating the proximity of a bomb (1, 2, and 3).
  
Dimensions based on difficulty level:
- Beginner level: 9 × 9 squares with 10 mines.
- Intermediate level: 16 × 16 squares with 40 mines.
- Expert level: 16 × 30 squares with 99 mines.
- Custom level: In this case, the user customizes their game by choosing the number of mines and the grid size.

# Structure UML diagram

![image](https://github.com/16pixar/Minesweeper-RISC-architecture/assets/125222286/b0539541-1eaf-4e67-800a-88b21c3f162b)
![image](https://github.com/16pixar/Minesweeper-RISC-architecture/assets/125222286/5533e65f-ff99-44aa-b5bc-8cb68d99eb41)
![image](https://github.com/16pixar/Minesweeper-RISC-architecture/assets/125222286/de2e1330-d178-4619-bb5b-f51962d1b9d2)





