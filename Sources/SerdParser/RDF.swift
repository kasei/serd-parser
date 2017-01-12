//
//  RDF.swift
//  SerdParser
//
//  Created by Gregory Todd Williams on 1/11/17.
//
//

import Foundation

public enum RDFTerm : CustomStringConvertible {
    case iri(String)
    case blank(String)
    case language(String, String)
    case datatype(String, String)
    
    public var description : String {
        // NOTE: While these are N-Triples-like, no escaping occurs here,
        //       and may lead to invalid data if you attempt to use them
        //       as actual N-Triples data.
        switch self {
        case .iri(let s):
            return "<\(s)>"
        case .blank(let b):
            return "_:\(b)"
        case .language(let s, let l):
            return "\"\(s)\"@\(l)"
        case .datatype(let s, "http://www.w3.org/2001/XMLSchema#string"):
            return "\"\(s)\""
        case .datatype(let s, let d):
            return "\"\(s)\"^^<\(d)>"
        }
    }
}

