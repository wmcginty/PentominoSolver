// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pentominos",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Pentominos",
            targets: ["Pentominos"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://www.github.com/Apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://www.github.com/Apple/swift-algorithms.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Pentominos",
            dependencies: [.product(name: "Collections", package: "swift-collections"),
                           .product(name: "Algorithms", package: "swift-algorithms")]),
        .testTarget(
            name: "PentominosTests",
            dependencies: ["Pentominos"]),
    ]
)
