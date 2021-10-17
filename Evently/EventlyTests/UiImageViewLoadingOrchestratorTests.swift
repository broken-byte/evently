//
//  UIImageViewLoadingOrchestratorTests.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/16/21.
//

import Foundation
import UIKit
import XCTest
@testable import Evently

class UiImageViewLoadingOrchestratorTests: XCTestCase {
    
    private var orchestrator: UiImageViewLoadingOrchestrator!
    private var mockImageLoader: MockImageLoader!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockImageLoader = MockImageLoader()
        let mockDispatchQueue = MockMainDispatchQueue()
        orchestrator = UiImageViewLoadingOrchestrator(imageLoader: mockImageLoader, dispatchQueue: mockDispatchQueue)
    }
    
    override func tearDownWithError() throws {
        mockImageLoader = nil
        orchestrator = nil
        try super.tearDownWithError()
    }
    
    func testThatOrchestratorCanLoadAnImageIntoAnImageView() throws {
        let uiImageView = UIImageView()
        if let testImageData: Data = Utilities.readDataFromLocalFile(withFileName: "test_image", ofType: "jpeg") {
            mockImageLoader.mockImageData = testImageData
        }
        mockImageLoader.shouldLoadSuccessfully = true
        let mockUrlString = "https://dummyImageUrl.com"
        
        uiImageView.loadImage(with: mockUrlString, and: orchestrator)
        
        XCTAssertNotNil(uiImageView.image)
    }
}
