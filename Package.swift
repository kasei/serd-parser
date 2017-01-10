import PackageDescription

let package = Package(
    name: "SwiftSerd",
    dependencies: [.Package(url: "../serd", versions: Version(0,0,1)..<Version(1,0,0))]
)
