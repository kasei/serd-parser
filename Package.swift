import PackageDescription

let package = Package(
    name: "SerdParser",
    targets: [
    	Target(
			name: "serd-parse",
			dependencies: [
				.Target(name: "SerdParser")
			]
		),
    ],
    dependencies: [
		.Package(url: "https://github.com/kasei/swift-serd.git", majorVersion: 0)
    ]
)

let lib = Product(name: "SerdParser", type: .Library(.Dynamic), modules: "SerdParser")
products.append(lib)
