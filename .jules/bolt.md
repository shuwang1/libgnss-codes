## 2026-07-08 - Array allocation optimization
**Learning:** Using `[Int16](repeating: 0, count: length)` in Swift allocates and zeroes out large buffers redundantly before immediately overwriting them in a tight loop.
**Action:** Use `[Int16](unsafeUninitializedCapacity: length) { buffer, initializedCount in ... }` for large buffer allocations in tight GNSS loops.
