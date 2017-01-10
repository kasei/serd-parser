import PackageDescription

let package = Package(
    name: "SerdParser",
    dependencies: [
		.Package(url: "https://github.com/kasei/swift-serd.git", majorVersion: 0)
    ]
)
