## 2024-05-18 - [Branchless LFSR for PRN Generation]
**Learning:** Pseudo-random noise (PRN) generation using Linear Feedback Shift Registers (LFSR) suffers from severe branch misprediction rates when using conditional logic (`if output != 0`) inside highly iterative inner loops (e.g., L2C code generation which runs up to 767,250 times).
**Action:** Use branchless bitwise arithmetic (e.g., `let mask = 0 &- output; state ^= (mask & taps)`) to avoid costly pipeline flushes in PRN generator loops.
## 2024-05-18 - Modulo operations and Array Initialization
**Learning:** Modulo operations (`%`) inside large loops are a significant performance bottleneck in Swift. Additionally, initializing arrays with zeros (`[Int16](repeating: 0, count: N)`) before fully overwriting them wastes CPU cycles and memory bandwidth.
**Action:** Replace modulo operations with loop splitting (processing indices before and after the wrap-around point separately). Use `[Int16](unsafeUninitializedCapacity: ...)` to initialize array buffers directly without zeroing them out first when you know the entire buffer will be overwritten.
