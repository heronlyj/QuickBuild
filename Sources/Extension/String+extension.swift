//
//  String+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//
import Foundation


extension String {
    
    //将空格都去除再组合
    public var removeWhitespace: String {
        return self.components(separatedBy: .whitespacesAndNewlines).filter({!$0.isEmpty}).joined(separator: " ")
    }
    
    public var isTelNumber: Bool {
        let pattern = "^1+[3578]+\\d{9}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

}


extension String {
    
    /// Returns a new string made from the `String` by replacing all characters not in the unreserved
    /// character set (As defined by RFC3986) with percent encoded characters.
    
    public var urlQueryParameter: String? {
        let allowedCharacters = NSMutableCharacterSet.allowedURLQueryParameter
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters as CharacterSet)
    }
    
    /// Returns a new string made from the `String` by replacing all characters not in the unreserved
    /// character set (as defined by W3C HTML specification for `application/x-www-form-urlencoded`
    /// requests) with percent encoded characters.
    
    public var formUrlencoded: String? {
        let allowedCharacters = NSMutableCharacterSet.allowedURLQueryParameter
        allowedCharacters.addCharacters(in: " ")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters as CharacterSet)?.replacingOccurrences(of: " ", with: "+")
    }
    
}

extension NSMutableCharacterSet {
    
    /// Returns the character set for characters allowed in the individual parameters within a query URL component.
    ///
    /// The query component of a URL is the component immediately following a question mark (?).
    /// For example, in the URL `http://www.example.com/index.php?key1=value1#jumpLink`, the query
    /// component is `key1=value1`. The individual parameters of that query would be the key `key1`
    /// and its associated value `value1`.
    ///
    /// According to RFC 3986, the set of unreserved characters includes
    ///
    /// `ALPHA / DIGIT / "-" / "." / "_" / "~"`
    ///
    /// In section 3.4 of the RFC, it further recommends adding `/` and `?` to the list of unescaped characters
    /// for the sake of compatibility with some erroneous implementations, so this routine also allows those
    /// to pass unescaped.
    
    public static var allowedURLQueryParameter: NSMutableCharacterSet {
        return self.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?")
    }
    
}


