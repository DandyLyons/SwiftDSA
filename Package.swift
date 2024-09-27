// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDSA",
    platforms: [
        .macOS(.v13), .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftDSA",
            targets: ["SwiftDSA"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark.git", from: "1.25.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftDSA"),
        .testTarget(
            name: "SwiftDSATests",
            dependencies: ["SwiftDSA"]
        ),
        .executableTarget(
            name: "SwiftDSABenchmark",
            dependencies: [
                "SwiftDSA",
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "BenchmarkPlugin", package: "package-benchmark"),
            ],
            path: "Benchmarks/Algorithms"
        ),
    ]
)
