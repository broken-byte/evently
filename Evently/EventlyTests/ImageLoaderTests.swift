//
//  ImageLoaderTests.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/4/21.
//

import Foundation
@testable import Evently
import XCTest

class ImageLoaderTests: XCTestCase {
    
    private var imageLoader: ImageLoader!
    private var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSession = MockURLSession()
        imageLoader = ImageLoader(urlSession: mockSession)
    }

    override func tearDownWithError() throws {
        mockSession = nil
        imageLoader = nil
        try super.tearDownWithError()
    }
    
    func testThatImageLoaderCanLoadAnImageGivenAnImageURL() throws {
        
    }
}

