//
//  MockURLSession.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 1/2/21.
//

import Foundation
@testable import Evently

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    
    private (set) var lastURL: URL?
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = url
        return nextDataTask
    }
}
