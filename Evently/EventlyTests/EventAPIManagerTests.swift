import XCTest
@testable import Evently

class EventManagerTests: XCTestCase, EventManagerDelegate {
    
    private var session: MockURLSession!
    private var dateTimeFormatter: MockDateFormatter!
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
        session = MockURLSession()
        dateTimeFormatter = MockDateFormatter()
        eventAPIManager = EventAPIManager(urlSession: session, dateTimeFormatter: dateTimeFormatter)
        eventAPIManager.delegate = self
    }

    override func tearDownWithError() throws {
        eventAPIManager = nil
        actualEvents = nil
        actualError = nil
    }
    
    func didFetchEvents(_ eventManager: EventAPIManager, fetchedEvents: [EventModel]) {
        actualEvents = fetchedEvents
    }
    
    func didFailWithError(_ error: Error) {
        actualError = error
    }

    func testThatEventAPIManagerSuccessfullyFetchesEventsFromAPI() throws {
        if let expectedMockData = readLocalFile(forName: "successful-seat-geek-api-data") {
            session.nextData = expectedMockData
        }
        let dummySuccessResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://seatgeek.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        session.nextResponse = dummySuccessResponse
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
    
    func testThatEventAPIManagerReturnsTheCorrectErrorOnBadNetworkResponse() throws {
        let dummyBadServerResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://seatgeek.com"),
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        session.nextResponse = dummyBadServerResponse
        let expectedError = EventAPIManager.HTTPResponseError.badServerResponse(dummyBadServerResponse)
        eventAPIManager.fetchEvents()
        XCTAssertEqual(expectedError.localizedDescription, actualError.localizedDescription)
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
