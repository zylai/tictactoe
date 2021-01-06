# Tic-tac-toe

Tic-tac-toe game written in Bash. Download and execute `ttt.sh` to play. Tested in Ubuntu 18 and macOS Catalina (10.15).

```
$ chmod +x ttt.sh
$ ./ttt.sh
    1   2   3
  |———|———|———|
A |   |   |   |
  |———|———|———|
B |   |   |   |
  |———|———|———|
C |   |   |   |
  |———|———|———|
Choose your move: 
```

The game creates a board.txt file in the directory it was executed in to keep track of the board. Currently, the "opponent" (computer) picks a random empty spot.

### Roadmap
- Computer algorithm that actually tries to tie or win the game instead of just randomly picking an empty spot.
