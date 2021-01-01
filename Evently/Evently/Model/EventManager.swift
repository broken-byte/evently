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
    
    public func fetchEvents() {
        let keys = EventlyKeys()
        let clientID = keys.seatGeekClientID
        let clientSecret = keys.seatGeekClientSecret
        let eventUrlString = "\(Constants.seatGeekURL)/events/?client_id=\(clientID)&client_secret=\(clientSecret)"
        performRequest(with: eventUrlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let fetchedEvents = self.parseJSON(safeData) {
                        self.delegate?.didFetchEvents(self , fetchedEvents: fetchedEvents)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ data: Data) -> [EventModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(EventData.self, from: data)
            var events: [EventModel] = []
            for event in decodedData.events {
                let title: String = event.title
                let imageURL: String = event.performers[0].image
                let location: String = event.venue.display_location
                let time: String = event.datetime_utc
                let event = EventModel(
                    title: title,
                    imageURL: imageURL,
                    location: location,
                    timeOfEventInUTC: time
                )
                events.append(event)
            }
            return events
        }
        catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
