## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.
## 2024-06-20 - [Performance Insight]
**Learning:** Found an opportunity in Swift implementation for GNSSCodes where bitwise operations can be used to prevent branch mispredictions. For example, `code[i] = ((xa & 1) ^ (xb & 1)) != 0 ? 1 : -1` can be optimized using shift and subtract.
**Action:** Replace conditional branches with branchless bitwise operations where applicable.
