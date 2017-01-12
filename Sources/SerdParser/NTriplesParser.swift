//
//  NTriplesParser.swift
//  SwiftSerd
//
//  Created by Gregory Todd Williams on 1/10/17.
//
//

import serd

fileprivate extension SerdNode {
    var value : String {
        return String(cString: self.buf)
    }
}

public class NTriplesParser {
	public init() {}
	
    fileprivate static func node_as_term(node : SerdNode, datatype : String?, language : String?) -> RDFTerm {
        switch node.type {
        case SERD_URI:
            return .iri(node.value)
        case SERD_BLANK:
            return .blank(node.value)
        case SERD_LITERAL:
            if let lang = language {
                return .language(node.value, lang)
            } else {
                return .datatype(node.value, datatype ?? "http://www.w3.org/2001/XMLSchema#string")
            }
        default:
            // We assume the data being parsed is N-Triples, so we should never see a CURIE
            fatalError("Unexpected SerdNode type: \(node.type)")
        }
    }
    
    @discardableResult
    public func parse(string: String, handleTriple: @escaping (RDFTerm, RDFTerm, RDFTerm) -> Void) -> Bool {
        let inputSyntax : SerdSyntax = SERD_NTRIPLES
        var baseUri = SERD_URI_NULL
        var base = SERD_NODE_NULL
        
        let env = serd_env_new(&base)
        base = serd_node_new_uri_from_string("http://base.example.org/", nil, &baseUri)
        
        let free_handle : @convention(c) (UnsafeMutableRawPointer?) -> Void = { (ptr) -> Void in }
        let base_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, node) -> SerdStatus in return SERD_SUCCESS }
        let prefix_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, name, uri) -> SerdStatus in return SERD_SUCCESS }
        
        let statement_sink : @convention(c) (UnsafeMutableRawPointer?, SerdStatementFlags, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, flags, graph, subject, predicate, object, datatype, language) -> SerdStatus in
            guard let handle = handle, let subject = subject, let predicate = predicate, let object = object else { return SERD_FAILURE }
            let ptr = handle.assumingMemoryBound(to: ((s : RDFTerm, p : RDFTerm, o : RDFTerm) -> Void).self)
            let handler = ptr.pointee
            
            let s = NTriplesParser.node_as_term(node: subject.pointee, datatype: nil, language: nil)
            let p = NTriplesParser.node_as_term(node: predicate.pointee, datatype: nil, language: nil)
            let o = NTriplesParser.node_as_term(node: object.pointee, datatype: datatype?.pointee.value, language: language?.pointee.value)
            
            handler(s, p, o)
            return SERD_SUCCESS
        }
        
        let end_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, node) -> SerdStatus in return SERD_SUCCESS }
        
        let error_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdError>?) -> SerdStatus = { (reader, error) in
            print("error: \(error)")
            return SERD_SUCCESS
        }
        
        var handler = handleTriple
        withUnsafePointer(to: &handler) { (h) -> Void in
            guard let reader = serd_reader_new(inputSyntax, UnsafeMutableRawPointer(mutating: h), free_handle, base_sink, prefix_sink, statement_sink, end_sink) else { fatalError() }
            
            serd_reader_set_strict(reader, true)
            serd_reader_set_error_sink(reader, error_sink, nil)
            
            _ = serd_reader_read_string(reader, string)
            serd_reader_free(reader)
        }
        serd_env_free(env)
        serd_node_free(&base)
        return true
    }
    
    @discardableResult
    public func parse(file filename: String, handleTriple: @escaping (RDFTerm, RDFTerm, RDFTerm) -> Void) -> Bool {
        guard let input = serd_uri_to_path(filename) else { print("no such file"); return false }
        
        let inputSyntax : SerdSyntax = SERD_NTRIPLES
        var baseUri = SERD_URI_NULL
        var base = SERD_NODE_NULL
        
        let env = serd_env_new(&base)
        base = serd_node_new_file_uri(input, nil, &baseUri, false)
        
        let free_handle : @convention(c) (UnsafeMutableRawPointer?) -> Void = { (ptr) -> Void in }
        let base_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, node) -> SerdStatus in return SERD_SUCCESS }
        let prefix_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, name, uri) -> SerdStatus in return SERD_SUCCESS }
        
        let statement_sink : @convention(c) (UnsafeMutableRawPointer?, SerdStatementFlags, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, flags, graph, subject, predicate, object, datatype, language) -> SerdStatus in
            guard let handle = handle, let subject = subject, let predicate = predicate, let object = object else { return SERD_FAILURE }
            let ptr = handle.assumingMemoryBound(to: ((s : RDFTerm, p : RDFTerm, o : RDFTerm) -> Void).self)
            let handler = ptr.pointee
            
            let s = NTriplesParser.node_as_term(node: subject.pointee, datatype: nil, language: nil)
            let p = NTriplesParser.node_as_term(node: predicate.pointee, datatype: nil, language: nil)
            let o = NTriplesParser.node_as_term(node: object.pointee, datatype: datatype?.pointee.value, language: language?.pointee.value)
            
            handler(s, p, o)
            return SERD_SUCCESS
        }
        
        let end_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdNode>?) -> SerdStatus = { (handle, node) -> SerdStatus in return SERD_SUCCESS }
        
        let error_sink : @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<SerdError>?) -> SerdStatus = { (reader, error) in
            print("error: \(error)")
            return SERD_SUCCESS
        }
        
        var handler = handleTriple
        withUnsafePointer(to: &handler) { (h) -> Void in
            guard let reader = serd_reader_new(inputSyntax, UnsafeMutableRawPointer(mutating: h), free_handle, base_sink, prefix_sink, statement_sink, end_sink) else { fatalError() }
            
            serd_reader_set_strict(reader, true)
            serd_reader_set_error_sink(reader, error_sink, nil)
            
            let in_fd = fopen(filename, "r")
            var status = serd_reader_start_stream(reader, in_fd, filename, false)
            while status == SERD_SUCCESS {
                status = serd_reader_read_chunk(reader)
            }
            serd_reader_end_stream(reader)
            serd_reader_free(reader)
        }
        serd_env_free(env)
        serd_node_free(&base)
        return true
    }
}
