import XCTest
@testable import Evently

class EventManagerTests: XCTestCase, EventManagerDelegate {
    
    private var mockSession: MockURLSession!
    private var mockDateTimeFormatter: MockDateFormatter!
    private var eventAPIManager: EventAPIManager!
    private var actualEvents: [EventModel]!
    private var actualError: Error!
    
    private enum APIResponseError: Error {
        case request
    }
    
    private enum FileReadError: Error {
        case failedToLoadJSON
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSession = MockURLSession()
        mockDateTimeFormatter = MockDateFormatter()
        eventAPIManager = EventAPIManager(
            urlSession: mockSession,
            dateTimeFormatter: mockDateTimeFormatter
        )
        eventAPIManager.delegate = self
    }

    override func tearDownWithError() throws {
        eventAPIManager = nil
        mockSession = nil
        mockDateTimeFormatter = nil
        actualEvents = nil
        actualError = nil
        try super.tearDownWithError()
    }
    
    func didFetchEvents(_ eventManager: EventAPIManager, fetchedEvents: [EventModel]) {
        actualEvents = fetchedEvents
    }
    
    func didFailWithError(_ error: Error) {
        actualError = error
    }

    func testThatManagerSuccessfullyFetchesEventsFromAPI() throws {
        guard let expectedMockData = Utilities.readDataFromLocalFile(
            withFileName: "successful_seat_geek_api_data",
            ofType: "json"
        ) else {
            fatalError("Failed to load data from local")
        }
        mockSession.mockData = expectedMockData
        let dummySuccessResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://seatgeek.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockResponse = dummySuccessResponse
        let expectedEvents: [EventModel] = [
            EventModel(
                title: "Folds of Honor QuikTrip 500",
                imageURL: "https://seatgeek.com/images/performers-landscape/folds-of-honor-quiktrip-500-1-4c93a3/622294/huge.jpg",
                location: "Hampton, GA",
                date: "Wed 12 May 2021",
                time: "03:30 AM"
            )
        ]
        eventAPIManager.fetchEvents()
        XCTAssertEqual(expectedEvents, actualEvents)
    }
    
    func testThatManagerSuccessfullyFetchesEventsGivenSearchQuery() {
        guard let expectedMockData = Utilities.readDataFromLocalFile(
            withFileName: "successful_seat_geek_api_data",
            ofType: "json"
        ) else {
            fatalError("Failed to load data from local")
        }
        mockSession.mockData = expectedMockData
        let dummySuccessResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://seatgeek.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockResponse = dummySuccessResponse
        let expectedEvents: [EventModel] = [
            EventModel(
                title: "Folds of Honor QuikTrip 500",
                imageURL: "https://seatgeek.com/images/performers-landscape/folds-of-honor-quiktrip-500-1-4c93a3/622294/huge.jpg",
                location: "Hampton, GA",
                date: "Wed 12 May 2021",
                time: "03:30 AM"
            )
        ]
        eventAPIManager.fetchEvents(searchQuery: "Folds")
        XCTAssertEqual(expectedEvents, actualEvents)
    }
    
    func testThatManagerReturnsTheCorrectErrorOnBadNetworkResponse() throws {
        let dummyBadServerResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://seatgeek.com"),
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockResponse = dummyBadServerResponse
        let expectedError = EventAPIManager.HTTPResponseError.badServerResponse(dummyBadServerResponse)
        eventAPIManager.fetchEvents()
        XCTAssertEqual(expectedError.localizedDescription, actualError.localizedDescription)
    }
}
