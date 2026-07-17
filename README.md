# libgnss-codes-swift

[![CI](https://github.com/shuwang1/Orientable-libgnss-code/actions/workflows/ci.yml/badge.svg)](https://github.com/shuwang1/Orientable-libgnss-code/actions/workflows/ci.yml)[![codecov](https://codecov.io/github/shuwang1/libgnss-codes/graph/badge.svg?token=AU8LKF6P02)](https://codecov.io/github/shuwang1/libgnss-codes)[![CodeFactor](https://www.codefactor.io/repository/github/shuwang1/libgnss-codes/badge)](https://www.codefactor.io/repository/github/shuwang1/libgnss-codes)[![Codacy Badge](https://app.codacy.com/project/badge/Grade/85cfb3a06b3140cbb8360a1e4c2d321e)](https://app.codacy.com/gh/shuwang1/libgnss-codes/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)[![CodeQL](https://github.com/shuwang1/libgnss-codes/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/shuwang1/libgnss-codes/actions/workflows/github-code-scanning/codeql)[![Dependabot Updates](https://github.com/shuwang1/libgnss-codes/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/shuwang1/libgnss-codes/actions/workflows/dependabot/dependabot-updates)[![Documentation](https://github.com/shuwang1/libgnss-codes/actions/workflows/docs.yml/badge.svg)](https://github.com/shuwang1/libgnss-codes/actions/workflows/docs.yml)[![pages-build-deployment](https://github.com/shuwang1/libgnss-codes/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/shuwang1/libgnss-codes/actions/workflows/pages/pages-build-deployment)

A modern, type-safe Swift 6.0 library for generating GNSS ranging codes across multiple constellations. 

This project is a high-performance port of the Oriental AI C library.

## Features

- **Swift-Native Architecture**: Built from the ground up for Swift 6.0, leveraging enums for type safety and Swift Package Manager (SPM) for seamless integration.
- **Multi-Constellation Support**:
  - **GPS**: L1 C/A, L1C (Pilot/Data/Overlay), L2C (CM/CL), L5 (I/Q)
  - **Galileo**: E1B/C, E5a (I/Q), E5b (I/Q)
  - **GLONASS**: G1 (C/A)
  - **BeiDou**: B1I
- **Memory Safe**: Replaces manual C memory management with Swift's automatic memory management and safe array buffers.
- **Bit-Perfect Parity**: Verified against the original C library and reference Matlab data.
- **Rich Documentation**: Integrated DocC support for browsable API documentation.

## Quick Start

### Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/shuwang1/libgnss-codes-swift.git", from: "1.0.0")
]
```

### Basic Usage

```swift
import GNSSCodes

// Generate GPS L1 C/A chips for PRN 1
if let code = GNSSCodes.generate(prn: 1, type: .L1CA) {
    print("Signal: GPS L1 C/A")
    print("Length: \(code.length) chips")
    print("Rate: \(code.chipRate / 1e6) MHz")
    print("First 5 chips: \(code.chips.prefix(5))")
}

// Generate Galileo E1B chips for PRN 10
if let galileo = GNSSCodes.generate(prn: 10, type: .E1B) {
    // Process Galileo chips...
}
```

## Documentation & Testing

- **Installation & Setup**: See [INSTALL.md](INSTALL.md) for detailed setup and build instructions.
- **Verification**: Run `swift test` to execute the comprehensive test suite.
- **API Reference**: Generate documentation with `swift package generate-documentation`.
- **CI/CD**: Automated builds and tests are performed via GitHub Actions on every push to `main`. Documentation is automatically deployed to GitHub Pages.

## Known Issues & Future Work

- **SIMD Optimization**: Currently, chips are represented as `[Int16]`. Transitioning to bit-packed `[UInt64]` with SIMD-accelerated correlation is planned for a future release.
- **Extended Constellation Support**: Porting of additional signals (e.g., L1 SBAS, NH10/20 integration) is ongoing.
- **Resource Management**: Galileo binary resources are currently bundled. Exploring dynamic downloading or more compact packing formats to reduce initial clone size.

## License

2016 All Rights Reserved by Shu Wang <shuwang1@outlook.com>
This project is licensed under the same terms as the original `libgnss-codes` library. See the [LICENSE](LICENSE) file (if available) or contact Shu Wang <shuwang1@outlook.com>.

## Credits

Original C implementation by [Shu Wang](mailto:shuwang1@outlook.com).
Swift port and optimization developed as part of Orientable AI internel C project.
