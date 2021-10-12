//
//  Utilities.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/12/21.
//

import Foundation

struct Utilities {
    
    static func readDataFromLocalFile(withFileName fileName: String, ofType fileType: String) -> Data? {
        let fileManager = FileManager.default
        if let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileType),
           let data = fileManager.contents(atPath: bundlePath) {
            return data
        }
        return nil
    }
}
