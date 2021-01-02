import XCTest
@testable import Evently

import Mocker

class EventManagerTests: XCTestCase, EventManagerDelegate {
    
    private var eventManager: EventManager!
    
    private var actualEvents: [EventModel]!
    private var eventsExpectation: XCTestExpectation!
    
    private var eventFetchError: Error!
    private var eventFetchErrorExpectation: XCTestExpectation!

    override func setUpWithError() throws {
        super.setUp()
        // TODO: Figure out how to successfully mock URLSession and JSONDecoder and inject thos into eventManager here so we can accurately test
        var eventManager = EventManager()
        eventManager.delegate = self
        
    }

    override func tearDownWithError() throws {
        super.tearDown()
        eventManager = nil
        actualEvents = nil
        eventsExpectation = nil
        eventFetchError = nil
        eventFetchErrorExpectation = nil
    }
    
    func didFetchEvents(_ eventManager: EventManager, fetchedEvents: [EventModel]) {
        actualEvents = fetchedEvents
        eventsExpectation.fulfill()
    }
    
    func didFailWithError(_ error: Error) {
        eventFetchError = error
        eventFetchErrorExpectation.fulfill()
        
    }

    func testThatEventManagerCanSuccessfullyFetchEvents() throws {
//        let configuration = URLSessionConfiguration.default
//        configuration.protocolClasses = [MockingURLProtocol.self]
//
//        let eventApiURL = URL(string: "https://api.seatgeek.com/2/events")!
//        let mock = Mock(
//            url: eventApiURL,
//            ignoreQuery: true,
//            dataType: .json,
//            statusCode: 200,
//            data: [
//                .get: MockedEventData.seatGeekApiJSON.data
//            ]
//        )
//        mock.register()
        eventsExpectation = expectation(description: "event JSON request should succeed")
        let expectedEvents: [EventModel] = [
            EventModel(
                title: "Folds of Honor QuikTrip 500",
                imageURL: "https://seatgeek.com/images/performers-landscape/folds-of-honor-quiktrip-500-1-4c93a3/622294/huge.jpg",
                location: "Hampton, GA",
                timeOfEventInUTC: "2021-01-01T08:30:00"
            )
        ]
        eventManager.fetchEvents()
        waitForExpectations(timeout: 2)
        XCTAssertEqual(expectedEvents, actualEvents)
    }
}
