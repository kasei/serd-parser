// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SerdParser",
    products: [
        .library(
            name: "SerdParser",
            targets: ["SerdParser"]),
    ],
    dependencies: [
        .package(name: "Cserd", url: "https://github.com/kasei/swift-serd.git", from: "0.0.0")
    ],
    targets: [
        .target(
            name: "SerdParser",
            dependencies: [
                .product(name: "serd", package: "Cserd")
            ]),
    ]
)

//let lib = Product(name: "SerdParser", type: .Library(.Dynamic), modules: "SerdParser")
//products.append(lib)
