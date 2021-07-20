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
    
    func testThatUiImageViewCanCreateADataTaskAndResume() throws {
        let expectedImage = #imageLiteral(resourceName: "DefaultEventImage")
        let expectedImageData = expectedImage.cgImage?.dataProvider?.data as Data?
        mockSession.nextData = expectedImageData!
        let dummySuccessResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://dummyImageUrl.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.nextResponse = dummySuccessResponse
        uiImageView.loadImage(with: "https://dummyImageUrl.com", and: mockSession)
        XCTAssertTrue(mockSession.nextDataTask.resumeWasCalled)
    }
}
