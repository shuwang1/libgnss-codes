## 2024-05-18 - [Eliminating Modulo Ops in Tight Signal DSP Loops]
**Learning:** Modulo (`%`) operators in tight Swift signal generation loops (like `generateWeilCode`) run 10,000+ times per generation and emit expensive `idiv` instructions, creating a performance bottleneck.
**Action:** Replace modulo logic in array index calculations with loop splitting (processing `0..<split` and `split..<end` separately) or using branch logic (`val += 1; if val == max { val = 0 }`) to dramatically improve generation speed without sacrificing readability.
