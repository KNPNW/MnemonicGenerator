// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MnemonicGenerator",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MnemonicGenerator",
            targets: ["MnemonicGenerator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tesseract-one/UncommonCrypto.swift.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "MnemonicGenerator",
            dependencies: ["UncommonCrypto"]
        ),
        .testTarget(
            name: "MnemonicGeneratorTests",
            dependencies: ["MnemonicGenerator"]
        ),
    ]
)

