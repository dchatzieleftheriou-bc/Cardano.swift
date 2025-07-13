// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let useLocalBinary = false

var package = Package(
    name: "Cardano",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "Cardano",
            targets: ["Cardano"])
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.1"),
        .package(name: "Bip39", url: "https://github.com/tesseract-one/Bip39.swift.git", from: "0.1.1"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.2"),
        .package(path: "CardanoCore")
    ],
    targets: [
        .target(
            name: "Cardano",
            dependencies: ["CardanoCore", "Bip39"]),
        .testTarget(
            name: "CardanoTests",
            dependencies: ["Cardano"])
    ]
)

#if os(Linux)
package.targets.append(
    .systemLibrary(name: "CCardano")
)
#else
package.targets.append(contentsOf: [
    .target(
        name: "CardanoBlockfrost",
        dependencies: ["Cardano", "BlockfrostSwiftSDK"],
        path: "Sources/Blockfrost"),
    .testTarget(
        name: "BlockfrostTests",
        dependencies: ["CardanoBlockfrost"])
])
package.products.append(
    .library(
        name: "CardanoBlockfrost",
        targets: ["CardanoBlockfrost"])
)
package.dependencies.append(
    .package(name: "BlockfrostSwiftSDK", url: "https://github.com/blockfrost/blockfrost-swift.git", from: "0.0.7")
)
#endif
