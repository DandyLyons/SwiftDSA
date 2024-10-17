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
        .package(url: "https://github.com/ordo-one/package-benchmark.git", from: "1.25.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.0.0"),
//        .package(url: "https://github.com/pointfreeco/swift-issue-reporting.git", from: "1.4.2"),
// As of 2024-10-16 there is a naming discrepancy that renders SPM in Xcode unable to resolve SwiftIssueReporting.
// This is because XCTestDynamicOverlay was renamed to SwiftIssueReporting.
// The only way I've found to import SwiftIssueReporting here is to depend on swift-custom-dump and import SwiftIssueReporting transitively through the swift-custom-dump package. 
    ],
    targets: [
        .target(
            name: "SwiftDSA",
            dependencies: [
                .product(name: "CustomDump", package: "swift-custom-dump"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "SwiftDSATests",
            dependencies: [
                "SwiftDSA",
                .product(name: "CustomDump", package: "swift-custom-dump"),
//                .product(name: "IssueReporting", package: "swift-issue-reporting"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
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
