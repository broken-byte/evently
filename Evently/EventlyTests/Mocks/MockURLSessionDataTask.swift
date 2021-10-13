//
//  MockURLSessionDataTask.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 1/15/21.
//

import Foundation
@testable import Evently

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    // Allows checking wether task was resumed or canceled outside module
    private (set) var resumeCallCount = 0
    private (set) var cancelCallCount = 0

    func resume() {
        resumeCallCount += 1
    }
    
    func cancel() {
        cancelCallCount += 1
    }
}
