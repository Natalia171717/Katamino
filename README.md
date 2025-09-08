## Katamino (game)

### Overview
This project is an implementation of the Katamino puzzle game using Prolog. Katamino is a logic and spatial reasoning game where players must fit a set of geometric pieces (similar to pentominoes) into a rectangular grid without leaving empty spaces. The purpose of this project is to explore constraint solving and backtracking techniques in Prolog, applying them to a real-world puzzle. The program can:
-Represent the Katamino board and pieces.
-Generate valid placements of pieces according to the rules. 

To properly understand and operate the system, please consult the [documentation](Consignas.pdf). The documentation is written in Spanish.

### How to run
- The code can be found in the 'base' folder.
- To execute the project, it is necessary to have SWI-Prolog installed on your device. It is recommended to run the program from a Linux terminal so that it works correctly (and the pieces can be properly displayed on the board).
- To run the program and test Katamino, navigate to the folder where the files katamino.pl and piezas.pl are located and type the following in the terminal:
```bash
swipl -s katamino.pl
```
Now you can try any predicate you want, both from katamino and from piezas.
The predicate llenarTablero is the one that solves the Katamino (showing all possible solutions for a given number of pieces). The implementation without pruning is inefficient, so it is recommended to use it with podaMod5.
```bash
llenarTablero(podaMod5, 4, T), mostrar(T).
```
