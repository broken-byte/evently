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
        if let expectedImageData = Utilities.readDataFromLocalFile(withFileName: "test_image", ofType: "jpeg") {
            mockSession.mockData = expectedImageData
        }
        let mockImageUrlString = "https://dummyImageUrl.com"
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://dummyImageUrl.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockError = nil
        
        var actualImage: UIImage?
        _ = imageLoader.loadImage(with: mockImageUrlString) { result in
            do {
                actualImage = try result.get()
            }
            catch {
                print(error)
            }
        }
        XCTAssertNotNil(actualImage!)
    }
}
