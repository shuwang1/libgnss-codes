## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.
## 2024-07-03 - [Branchless Arithmetic in Ternary Math]
**Learning:** Another instance of branchless math mapping `0 -> -1` and `1 -> 1` avoids conditional branches. Using `let output = condition; return (output << 1) - 1` replaces `return condition ? 1 : -1`, which is particularly effective in high-frequency generation loops like PRN signal generation (`generateL5`, running 10,230 times per PRN).
**Action:** Always prefer mathematical formulations for binary state mapping (`0`/`1` to `-1`/`1`) in tight loops, applying branchless design.
