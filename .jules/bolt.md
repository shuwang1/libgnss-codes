## 2026-07-08 - Array allocation optimization
**Learning:** Using `[Int16](repeating: 0, count: length)` in Swift allocates and zeroes out large buffers redundantly before immediately overwriting them in a tight loop.
**Action:** Use `[Int16](unsafeUninitializedCapacity: length) { buffer, initializedCount in ... }` for large buffer allocations in tight GNSS loops.
## 2024-07-10 - Array allocation optimization
**Learning:** In tight loops generating large arrays (like GNSS chips), using `[Int16](repeating: 0, count: N)` is a bottleneck because it allocates and manually zeroes memory. `[Int16](unsafeUninitializedCapacity: N)` should be preferred when the array is guaranteed to be fully overwritten immediately after allocation. However, manually zeroing an array inside the closure using a `for` loop is an anti-pattern and often slower than Swift's optimized underlying `memset` for `repeating: 0`.
**Action:** Use `unsafeUninitializedCapacity` only when the array contents are completely written to immediately and you don't need to manually zero them.
