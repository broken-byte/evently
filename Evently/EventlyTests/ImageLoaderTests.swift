//
//  ImageLoaderTests.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/4/21.
//

import Foundation
import XCTest
@testable import Evently

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
            url: URL(fileURLWithPath: mockImageUrlString),
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
    
    func testThatImageLoaderCanLoadAnImageFromCacheAfterInitialDownload() throws {
        if let expectedImageData = Utilities.readDataFromLocalFile(withFileName: "test_image", ofType: "jpeg") {
            mockSession.mockData = expectedImageData
        }
        let mockUrlString = "https://dummyImageUrl.com"
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: mockUrlString),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockError = nil
        
        var actualImage:UIImage?
        for _ in 0...1 { // Initial download, then cache hit
            _ = imageLoader.loadImage(with: mockUrlString) { result in
                do {
                    actualImage = try result.get()
                }
                catch {
                    print(error)
                }
            }
            XCTAssertNotNil(actualImage!)
            XCTAssertTrue(mockSession.mockDataTask.resumeCallCount == 1)
        }
    }
    
    func testThatImageLoaderCanCancelAnImageLoad() throws {
        if let expectedImageData = Utilities.readDataFromLocalFile(withFileName: "test_image", ofType: "jpeg") {
            mockSession.mockData = expectedImageData
        }
        let mockUrlString = "https://dummyImageUrl.com"
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: mockUrlString),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockError = nil
        
        let task: UUID? = imageLoader.loadImage(with: mockUrlString) { result in
            do {
                _ = try result.get()
            }
            catch {
                print(error)
            }
        }
        if let safeTask = task {
            imageLoader.cancelLoad(safeTask)
        }
        XCTAssertTrue(mockSession.mockDataTask.cancelCallCount == 1)
    }
}
