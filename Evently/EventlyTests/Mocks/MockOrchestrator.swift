//
//  MockOrchestrator.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 11/1/21.
//

import Foundation
import UIKit
@testable import Evently

class MockOrchestrator: UiImageViewLoadingOrchestratorProtocol {
    
    private (set) var loadCallCount = 0
    private (set) var cancelCallCount = 0
    private (set) var mockImage: UIImage?
    
    public var shouldLoadSuccessfully = false
    
    func load(with imageUrlString: String, for imageView: UIImageView) {
        loadCallCount += 1
        if (shouldLoadSuccessfully) {
            if let expectedImageData = Utilities.readDataFromLocalFile(withFileName: "test_image", ofType: "jpeg") {
                mockImage = UIImage(data: expectedImageData)
            }
        }
        else {
            imageView.image = #imageLiteral(resourceName: "DefaultEventImage")  // default image
        }
    }
    
    func cancel(for imageView: UIImageView) {
        cancelCallCount += 1
    }
}
