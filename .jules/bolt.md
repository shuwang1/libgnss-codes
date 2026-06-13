## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.
## 2024-05-18 - [Branchless LFSR for L5 PRN Generation]
**Learning:** Similarly to L2C generation, pseudo-random noise generation for L5 using LFSR suffers from severe branch misprediction rates when using ternary assignments (`code[i] = ((xa & 1) ^ (xb & 1)) != 0 ? 1 : -1`) inside highly iterative inner loops (e.g., L5 code generation which runs 10,230 times per call).
**Action:** Use branchless bitwise arithmetic (e.g., `let output = (xa & 1) ^ (xb & 1); code[i] = Int16(output << 1) - Int16(1)`) to avoid costly pipeline flushes in PRN generator loops. This maps 0 to -1 and 1 to 1 branchlessly.
