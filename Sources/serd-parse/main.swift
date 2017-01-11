import Foundation
import SerdParser

guard CommandLine.arguments.count == 2 else {
    let info = ProcessInfo.processInfo
    print("Usage: \(info.processName) filename.nt\n")
    exit(1)
}

let filename = CommandLine.arguments[1]
let parser = NTriplesParser()
var count = 0
parser.parse(file: filename) { (s, p, o) in
    count += 1
    print("\(s) \(p) \(o) .")
}
print("# \(count) triples parsed")
