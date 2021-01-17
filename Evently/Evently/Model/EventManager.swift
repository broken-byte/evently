//
//  EventManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation
import Keys

protocol EventManagerDelegate {
    func didFetchEvents(_ eventManager: EventManager, fetchedEvents: [EventModel])
    func didFailWithError(_ error: Error)
}

struct EventManager {
    
    public var delegate: EventManagerDelegate?
    private let session: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.session = urlSession
    }
    
    public func fetchEvents() {
        let keys = EventlyKeys()
        let clientID = keys.seatGeekClientID
        let clientSecret = keys.seatGeekClientSecret
        let eventUrlString = "\(Constants.seatGeekURL)/events/?client_id=\(clientID)&client_secret=\(clientSecret)"
        print(eventUrlString)
        performRequest(with: eventUrlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let task = session.dataTask(with: url, completion: { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.delegate?.didFailWithError(HTTPResponseError.badServerResponse(response))
                    return
                }
                if let safeData = data {
                    if let fetchedEvents = self.parseJSON(safeData) {
                        self.delegate?.didFetchEvents(self , fetchedEvents: fetchedEvents)
                    }
                }
            })
            task.resume()
        }
        else {
            delegate?.didFailWithError(URLError.invalidInput(urlString))
        }
    }
    
    private func parseJSON(_ data: Data) -> [EventModel]? {
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(EventData.self, from: data)
            var modeledEvents: [EventModel] = []
            for eventData in decodedData.events {
                let eventModel = createEventModel(from: eventData)
                modeledEvents.append(eventModel)
            }
            return modeledEvents
        }
        catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    private func createEventModel(from eventData: Event) -> EventModel {
        let title: String = eventData.title
        let imageURL: String = eventData.performers[0].image
        let location: String = eventData.venue.display_location
        let time: String = eventData.datetime_utc
        let eventModel = EventModel(
            title: title,
            imageURL: imageURL,
            location: location,
            timeOfEventInUTC: time
        )
        return eventModel
    }
}

//MARK: - Error Enumerations

extension EventManager {
    enum URLError: Error {
        case invalidInput(_ urlString: String)
    }

    enum HTTPResponseError: Error {
        case badServerResponse(_ response: URLResponse?)
    }
}

