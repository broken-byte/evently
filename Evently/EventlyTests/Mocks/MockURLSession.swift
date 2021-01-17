//
//  MockURLSession.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 1/2/21.
//

import Foundation
@testable import Evently

class MockURLSession: URLSessionProtocol {
    
    var nextData: Data?
    var nextResponse: HTTPURLResponse?
    var nextError: Error?
    var nextDataTask = MockURLSessionDataTask()
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completion(nextData, nextResponse, nextError)
        return nextDataTask
    }
}
