//
//  MockImageLoader.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/15/21.
//

import Foundation
import UIKit
@testable import Evently

class MockImageLoader: ImageLoaderProtocol {
    
    private (set) var loadCallCount = 0
    private (set) var cancelCallCount = 0
    
    public var shouldLoadSuccessfully = false
    public var mockImageData: Data?
    public enum mockError: Error {
        case mockError
    }
    
    func loadImage(with imageUrlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        loadCallCount += 1
        if (!shouldLoadSuccessfully) {
            let mockError = mockError.mockError
            completion(.failure(mockError))
            return nil
        }
        let mockUUID = UUID()
        if let safeMockImageData = mockImageData, let testImage = UIImage(data: safeMockImageData) {
            completion(.success(testImage))
        }
        return mockUUID
    }
    
    func cancelLoad(_ uuid: UUID) {
        cancelCallCount += 1
    }
    
    
}
