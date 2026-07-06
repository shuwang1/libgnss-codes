🎯 **What:** The vulnerability fixed
Fixed an out-of-bounds array access vulnerability in `hex2bin` and `oct2bin` helper functions in `Sources/GNSSCodes/GNSSCodes.swift`. Previously, these functions accessed characters from an array using a loop from `0..<n` without verifying that `i` was within the bounds of `chars.count`.

⚠️ **Risk:** The potential impact if left unfixed
If `n` is greater than the length of the string passed into `hex2bin` or `oct2bin`, accessing `chars[i]` would trigger an out-of-bounds crash (`Fatal error: Index out of range`). This can lead to unexpected application crashes or potential denial-of-service (DoS) if externally controlled input is passed into these functions.

🛡️ **Solution:** How the fix addresses the vulnerability
Added a bounds check (`guard i < chars.count else { break }`) inside the loops of both `hex2bin` and `oct2bin`. If `i` exceeds the bounds of the array, the loop breaks gracefully, preventing the out-of-bounds access while properly returning the parsed values up to the valid length.

**Note on Testing:** The `swift` toolchain is not available locally in the development environment, so local testing could not be executed. Detailed manual verification was performed on the code logic, and full verification will rely on the CI/CD pipeline once the PR is pushed.
