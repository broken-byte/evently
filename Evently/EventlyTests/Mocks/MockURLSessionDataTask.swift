//
//  MockURLSessionDataTask.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 1/15/21.
//

import Foundation
@testable import Evently

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        cancelWasCalled = true
    }
}
