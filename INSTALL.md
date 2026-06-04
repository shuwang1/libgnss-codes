# Installation and Usage Guide

This project is a Swift 6.0 port of the `libgnss-codes` C library. It provides high-performance GNSS ranging code generation for GPS, Galileo, GLONASS, and BeiDou.

## Prerequisites

- **Swift 6.0+**: Ensure you have the latest Swift toolchain installed.
  - macOS: Install via Xcode or from [swift.org](https://swift.org).
  - Linux: Follow the installation instructions on [swift.org](https://swift.org).

## Installation

### As a Dependency in a Swift Package

Add `libgnss-codes-swift` to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/shuwang1/libgnss-codes-swift.git", from: "1.0.0")
]
```

Then, add it to your target's dependencies:

```swift
targets: [
    .target(
        name: "MyTarget",
        dependencies: [
            .product(name: "GNSSCodes", package: "libgnss-codes-swift")
        ]
    )
]
```

## Testing

To verify the installation and ensure all GNSS codes are generated correctly:

```bash
swift test
```

This will run the comprehensive test suite covering GPS, Galileo, GLONASS, and BeiDou signals.

## Usage

Import the module in your Swift code and use the unified `generate` API:

```swift
import GNSSCodes

// Generate GPS L1 C/A code for PRN 1
if let code = GNSSCodes.generate(prn: 1, type: .L1CA) {
    print("Generated \(code.length) chips at \(code.chipRate) Hz")
    print("First 10 chips: \(code.chips.prefix(10))")
}

// Generate Galileo E1B code for PRN 10
if let e1bCode = GNSSCodes.generate(prn: 10, type: .E1B) {
    // Process Galileo chips...
}
```

### Supported Signal Types

The library supports a wide range of signals via the `CodeType` enum:
- **GPS**: `.L1CA`, `.L1CP`, `.L1CD`, `.L1CO`, `.L2CM`, `.L2CL`, `.L5I`, `.L5Q`
- **Galileo**: `.E1B`, `.E1C`, `.E5AI`, `.E5AQ`, `.E5BI`, `.E5BQ`
- **BeiDou**: `.B1I`
- **GLONASS**: `.G1`
- **Others**: `.NH10`, `.NH20` (Neuman-Hoffman overlay codes)

## Documentation

The project includes the `swift-docc-plugin`. You can generate rich API documentation using Swift DocC:

```bash
swift package generate-documentation
```

To preview the documentation in your browser (starts a local web server):

```bash
swift package --disable-sandbox preview-documentation --target GNSSCodes
```

## Build Options

Build for release (optimized):

```bash
swift build -c release
```
