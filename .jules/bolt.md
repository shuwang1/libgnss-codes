## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.

## 2024-05-24 - [UnsafeMutableBufferPointer vs Array Append]
**Learning:** When generating expanded codes (like BOC modulation), using `.append()` in a loop causes unnecessary capacity checks and reallocation overhead. Additionally, a second pass for negation can be merged.
**Action:** Allocate the array upfront with `repeating: 0` and use `.withUnsafeMutableBufferPointer` combined with a single pass to eliminate reallocation and redundant iterations.
