//
//  MockURLSession.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 1/2/21.
//

import Foundation
@testable import Evently

class MockURLSession: URLSessionProtocol {
    
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    var mockError: Error?
    var mockDataTask = MockURLSessionDataTask()
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        // flattens asynchronous call
        completion(mockData, mockResponse, mockError)
        return mockDataTask
    }
}
