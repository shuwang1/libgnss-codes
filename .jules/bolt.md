## 2024-06-16 - Array Allocation vs Branchless Math in Swift LFSRs
**Learning:** In this GNSS code generator, replacing simple ternary logic like `(i % 2 == 0) ? -1 : 1` with bitwise math does NOT improve performance because the LLVM compiler natively optimizes this into branchless CSEL/CMOV instructions. Instead, local 2D array initializations (used as lookups) inside frequently called functions (like `hex2bin`) cause repeated, expensive heap allocations in Swift.
**Action:** When optimizing loop-heavy Swift functions, focus on moving array literals out of local scope or replacing them with direct mathematical calculations rather than attempting to hand-write branchless logic over basic conditionals.
## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.
## 2024-07-03 - [Branchless Arithmetic in Ternary Math]
**Learning:** Another instance of branchless math mapping `0 -> -1` and `1 -> 1` avoids conditional branches. Using `let output = condition; return (output << 1) - 1` replaces `return condition ? 1 : -1`, which is particularly effective in high-frequency generation loops like PRN signal generation (`generateL5`, running 10,230 times per PRN).
**Action:** Always prefer mathematical formulations for binary state mapping (`0`/`1` to `-1`/`1`) in tight loops, applying branchless design.
## 2024-05-18 - [Branchless LFSR for L5 PRN Generation]
**Learning:** Similarly to L2C generation, pseudo-random noise generation for L5 using LFSR suffers from severe branch misprediction rates when using ternary assignments (`code[i] = ((xa & 1) ^ (xb & 1)) != 0 ? 1 : -1`) inside highly iterative inner loops (e.g., L5 code generation which runs 10,230 times per call).
**Action:** Use branchless bitwise arithmetic (e.g., `let output = (xa & 1) ^ (xb & 1); code[i] = Int16(output << 1) - Int16(1)`) to avoid costly pipeline flushes in PRN generator loops. This maps 0 to -1 and 1 to 1 branchlessly.

## 2024-10-24 - [LLVM Branchless Optimizations & Heap Pressure]
**Learning:** Manual branchless bitwise arithmetic to replace simple ternary operators is an anti-pattern. Modern Swift compilers (LLVM) automatically optimize simple ternaries into branchless conditional instructions (CMOV/CSEL). Additionally, allocating static lookup tables locally within frequently called helper functions (like `oct2bin`) causes unnecessary, repeated heap allocations and deallocations.
**Action:** Rely on LLVM to optimize simple ternaries for better readability, and prioritize hoisting local array allocations in frequently called paths to static properties to reduce heap pressure and garbage collection overhead.
