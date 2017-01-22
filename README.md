serd-parser
===

This is an example project to show the use of the
[Serd RDF library](http://drobilla.net/software/serd)
to parse N-Triples data in Swift.

From the command line:

    % swift build
    % ./.build/debug/serd-parse foaf.ttl
    <http://kasei.us/about/#greg> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://xmlns.com/foaf/0.1/Person> .
    <http://kasei.us/about/#greg> <http://xmlns.com/foaf/0.1/name> "Gregory Todd Williams" .
    <http://kasei.us/about/#greg> <http://xmlns.com/foaf/0.1/nick> "kasei" .
    <http://kasei.us/about/#greg> <http://xmlns.com/foaf/0.1/mbox> <mailto://greg@evilfunhouse.com> .
    <http://kasei.us/about/#greg> <http://xmlns.com/foaf/0.1/mbox_sha1sum> "f80a0f19d2a0897b89f48647b2fb5ca1f0bc1cb8" .
    <http://kasei.us/about/#greg> <http://xmlns.com/foaf/0.1/homepage> <http://kasei.us/> .
    <http://kasei.us/about/#greg> <http://xmlns.com/foaf/0.1/img> <http://kasei.us/images/greg.png> .
    ...

Or, programatically:

    import SerdParser
    
    // extract all foaf:name triples
    let parser = SerdParser()
    let count = try parser.parse(file: filename) { (s, p, o) in
        if case .iri("http://xmlns.com/foaf/0.1/name") = p {
            print("\(s) has name \(o) .")
        }
    }
    print("\(count) triples processed")
