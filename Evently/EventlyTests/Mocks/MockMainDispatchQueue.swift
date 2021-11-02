//
//  MockMainDispatchQueue.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/17/21.
//

import Foundation
@testable import Evently

final class MockMainDispatchQueue: DispatchQueueProtocol {
    func async(execute work: @escaping @convention(block) () -> Void) {
        // Flattens asynchronous call
        work()
    }
}
