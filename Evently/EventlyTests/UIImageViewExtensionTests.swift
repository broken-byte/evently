//
//  UIImageViewExtensionTests.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 7/19/21.
//

import XCTest
@testable import Evently

class UIImageViewExtensionTests: XCTestCase {
    
    private var mockSession: MockURLSession!
    private var uiImageView: UIImageView!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        uiImageView = UIImageView()
    }
    
    override func tearDownWithError() throws {
        mockSession = nil
        uiImageView = nil
    }
    
//    func testThatUiImageViewCanLoadAnImageCorrectly() throws {
//        let expectedInitialImage: UIImage? = #imageLiteral(resourceName: "DefaultEventImage")
//        let expectedImageData = expectedInitialImage?.pngData()
//        let expectedImage = UIImage(data: expectedImageData!)
//        mockSession.nextData = expectedImageData
//        let mockUrlString = "https://dummyImageUrl.com"
//        let dummySuccessResponse = HTTPURLResponse(
//            url: URL(fileURLWithPath: mockUrlString),
//            statusCode: 200,
//            httpVersion: nil,
//            headerFields: nil
//        )
//        mockSession.nextResponse = dummySuccessResponse
//
//        var actualImage: UIImage?
//        let expectation = self.expectation(description: "Loading image")
//        UIImageLoadingHandler.urlSession = mockSession
//        uiImageView.loadImage(with: mockUrlString)
//        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssertEqual(expectedImage?.pngData(), actualImage?.pngData())
//    }

//    func testThatUiImageViewCanReturnCorrectErrorGivenABadNetworkResponse() throws {
//        let mockUrlString = "https://dummyImageUrl.com"
//        let expectation = self.expectation(description: "Pretending to load image")
//        let dummyBadServerResponse = HTTPURLResponse(
//            url: URL(fileURLWithPath: "https://dummyImageUrl.com"),
//            statusCode: 500,
//            httpVersion: nil,
//            headerFields: nil
//        )
//        let expectedError = UIImageView.NetworkError.badServerResponse(dummyBadServerResponse)
//        var actualError: Error?
//        uiImageView.loadImage(with: mockUrlString, and: mockSession) { result in
//            do {
//                try result.get()
//            } catch {
//                expectation.fulfill()
//                actualError = error
//            }
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssertEqual(expectedError.localizedDescription, actualError?.localizedDescription)
//    }
}
