import XCTest
@testable import Evently

class EventManagerTests: XCTestCase, EventManagerDelegate {
    
    private var eventManager: EventManager!
    private var actualEvents: [EventModel]!
    private var eventsExpectation: XCTestExpectation!
    private var eventFetchError: Error!
    private var eventFetchErrorExpectation: XCTestExpectation!
    
    private enum APIResponseError: Error {
        case request
    }
    
    private enum FileReadError: Error {
        case failedToLoadJSON
    }

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        eventManager = EventManager(urlSession: urlSession)
        eventManager.delegate = self
        
    }

    override func tearDownWithError() throws {
        eventManager = nil
        actualEvents = nil
        eventsExpectation = nil
        eventFetchError = nil
        eventFetchErrorExpectation = nil
    }
    
    func didFetchEvents(_ eventManager: EventManager, fetchedEvents: [EventModel]) {
        actualEvents = fetchedEvents
        eventsExpectation?.fulfill()
    }
    
    func didFailWithError(_ error: Error) {
        eventFetchError = error
        eventFetchErrorExpectation?.fulfill()
        
    }

    func testFetchEventsOnSuccess() throws {
        let apiURL = URL(string: "https://api.seatgeek.com/2/events/?client_id=MjE0MzE2NDV8MTYwNzg4MTA4MS41OTA5OTYz&client_secret=19838d1a55ef49f1ac0090cff6463d3ee040e0ff8993606e307da9e2ce5a9d6d")!
        if let mockedSuccessData = readLocalFile(forName: "successful-seat-geek-api-data") {
            MockURLProtocol.requestHandler = { request in
              guard let url = request.url, url == apiURL else {
                throw APIResponseError.request
              }
              let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
              return (response, mockedSuccessData)
            }
        }
        
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
    
    private func readLocalFile(forName name: String) -> Data? {
        var data: Data?
              if let path = Bundle.main.path(forResource: name, ofType: "json") {
                  do {
                      let fileUrl = URL(fileURLWithPath: path)
                      // Getting data from JSON file using the file URL
                      data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                      //json = try? JSONSerialization.jsonObject(with: data)
                  } catch {
                    print(error)
                  }
              }
              return data
    }
}
