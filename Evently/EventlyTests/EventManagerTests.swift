import XCTest
@testable import Evently

class EventManagerTests: XCTestCase, EventManagerDelegate {
    
    private var session: MockURLSession!
    
    private var eventManager: EventManager!
    
    private var actualEvents: [EventModel]!
    
    private var eventFetchError: Error!
    
    private var eventFetchErrorExpectation: XCTestExpectation!
    
    private enum APIResponseError: Error {
        case request
    }
    
    private enum FileReadError: Error {
        case failedToLoadJSON
    }

    override func setUpWithError() throws {
        session = MockURLSession()
        eventManager = EventManager(urlSession: session)
        eventManager.delegate = self
    }

    override func tearDownWithError() throws {
        eventManager = nil
        actualEvents = nil
        eventFetchError = nil
        eventFetchErrorExpectation = nil
    }
    
    func didFetchEvents(_ eventManager: EventManager, fetchedEvents: [EventModel]) {
        actualEvents = fetchedEvents
    }
    
    func didFailWithError(_ error: Error) {
        eventFetchError = error
        //eventFetchErrorExpectation?.fulfill()
        
    }

    func testThatFetchEventsSuccessfullyFetchesEventsFromAPI() throws {
        if let expectedMockData = readLocalFile(forName: "successful-seat-geek-api-data") {
            session.nextData = expectedMockData
        }
        if let dummySuccessResponse = HTTPURLResponse(
            url: URL(fileURLWithPath: "https://seatgeek.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ) {
            session.nextResponse = dummySuccessResponse
        }
        let expectedEvents: [EventModel] = [
            EventModel(
                title: "Folds of Honor QuikTrip 500",
                imageURL: "https://seatgeek.com/images/performers-landscape/folds-of-honor-quiktrip-500-1-4c93a3/622294/huge.jpg",
                location: "Hampton, GA",
                timeOfEventInUTC: "2021-01-01T08:30:00"
            )
        ]
        eventManager.fetchEvents()
        XCTAssertEqual(expectedEvents[0].title, actualEvents[0].title)
        XCTAssertEqual(expectedEvents[0].imageURL, actualEvents[0].imageURL)
        XCTAssertEqual(expectedEvents[0].location, actualEvents[0].location)
        XCTAssertEqual(expectedEvents[0].timeOfEventInUTC, actualEvents[0].timeOfEventInUTC)
        XCTAssertEqual(expectedEvents[0].timeOfEventInLocalFormat, actualEvents[0].timeOfEventInLocalFormat)
    }
    
    func testThatFetchEventsReturnsTheCorrectErrorOnBadNetworkResponse() throws {
        
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
