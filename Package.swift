import PackageDescription

let package = Package(
    name: "serd-parser",
    dependencies: [
		.Package(url: "https://github.com/kasei/swift-serd.git", majorVersion: 0)
    ]
)
