## 2024-06-09 - Swift Compiler Crash on String/Array Processing
**Learning:** The Swift 6.0 compiler being used crashes during compilation (`signal 11` in `clang::RawComment::RawComment`) when dealing with `GNSSCodes.swift`. It is impossible to use `swift test`, `swift run`, or `swift build` directly for basic validation in this environment because the Swift package setup or compiler versions have some deep issue parsing comments or specific syntax in this project.
**Action:** The focus of optimization in this PR is replacing `let chars = Array(hex)` and `let chars = Array(oct)` in `GNSSCodes.swift` with direct string iteration (e.g., using `hex.utf8` or direct index access) which is standard practice in Swift for performance, avoiding O(N) array allocation. Given compiler crashes, I will rely on standard Swift optimization techniques knowing the environment cannot verify it.
## 2024-06-09 - Workaround for test verifications
**Learning:** Even copying the files without comments doesn't help the Swift 6.0 compiler run tests. The problem is a compiler bug processing Swift sources in this specific container.
**Action:** Since we cannot run tests directly, I rely on the careful verification of the logic, validating it doesn't break syntax and logically does exactly the same array extraction of characters but using `.utf8` bytes instead of the high-level `Array(String)` string parser logic.
## 2024-05-18 - [Eliminating Modulo Ops in Tight Signal DSP Loops]
**Learning:** Modulo (`%`) operators in tight Swift signal generation loops (like `generateWeilCode`) run 10,000+ times per generation and emit expensive `idiv` instructions, creating a performance bottleneck.
**Action:** Replace modulo logic in array index calculations with loop splitting (processing `0..<split` and `split..<end` separately) or using branch logic (`val += 1; if val == max { val = 0 }`) to dramatically improve generation speed without sacrificing readability.
## 2024-06-16 - Array Allocation vs Branchless Math in Swift LFSRs
**Learning:** In this GNSS code generator, replacing simple ternary logic like `(i % 2 == 0) ? -1 : 1` with bitwise math does NOT improve performance because the LLVM compiler natively optimizes this into branchless CSEL/CMOV instructions. Instead, local 2D array initializations (used as lookups) inside frequently called functions (like `hex2bin`) cause repeated, expensive heap allocations in Swift.
**Action:** When optimizing loop-heavy Swift functions, focus on moving array literals out of local scope or replacing them with direct mathematical calculations rather than attempting to hand-write branchless logic over basic conditionals.
## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.
## 2024-06-20 - [Performance Insight]
**Learning:** Found an opportunity in Swift implementation for GNSSCodes where bitwise operations can be used to prevent branch mispredictions. For example, `code[i] = ((xa & 1) ^ (xb & 1)) != 0 ? 1 : -1` can be optimized using shift and subtract.
**Action:** Replace conditional branches with branchless bitwise operations where applicable.

## 2024-05-24 - [UnsafeMutableBufferPointer vs Array Append]
**Learning:** When generating expanded codes (like BOC modulation), using `.append()` in a loop causes unnecessary capacity checks and reallocation overhead. Additionally, a second pass for negation can be merged.
**Action:** Allocate the array upfront with `repeating: 0` and use `.withUnsafeMutableBufferPointer` combined with a single pass to eliminate reallocation and redundant iterations.
## 2024-07-03 - [Branchless Arithmetic in Ternary Math]
**Learning:** Another instance of branchless math mapping `0 -> -1` and `1 -> 1` avoids conditional branches. Using `let output = condition; return (output << 1) - 1` replaces `return condition ? 1 : -1`, which is particularly effective in high-frequency generation loops like PRN signal generation (`generateL5`, running 10,230 times per PRN).
**Action:** Always prefer mathematical formulations for binary state mapping (`0`/`1` to `-1`/`1`) in tight loops, applying branchless design.
## 2024-05-18 - [Branchless LFSR for L5 PRN Generation]
**Learning:** Similarly to L2C generation, pseudo-random noise generation for L5 using LFSR suffers from severe branch misprediction rates when using ternary assignments (`code[i] = ((xa & 1) ^ (xb & 1)) != 0 ? 1 : -1`) inside highly iterative inner loops (e.g., L5 code generation which runs 10,230 times per call).
**Action:** Use branchless bitwise arithmetic (e.g., `let output = (xa & 1) ^ (xb & 1); code[i] = Int16(output << 1) - Int16(1)`) to avoid costly pipeline flushes in PRN generator loops. This maps 0 to -1 and 1 to 1 branchlessly.

## 2024-10-24 - [LLVM Branchless Optimizations & Heap Pressure]
**Learning:** Manual branchless bitwise arithmetic to replace simple ternary operators is an anti-pattern. Modern Swift compilers (LLVM) automatically optimize simple ternaries into branchless conditional instructions (CMOV/CSEL). Additionally, allocating static lookup tables locally within frequently called helper functions (like `oct2bin`) causes unnecessary, repeated heap allocations and deallocations.
**Action:** Rely on LLVM to optimize simple ternaries for better readability, and prioritize hoisting local array allocations in frequently called paths to static properties to reduce heap pressure and garbage collection overhead.
