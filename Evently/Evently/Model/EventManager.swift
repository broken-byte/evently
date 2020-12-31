//
//  EventManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation
import Keys

protocol EventManagerDelegate {
    func didFetchEvents(_ fetchedEvents: [EventModel])
}

struct EventManager {

    var delegate: EventManagerDelegate?
    
    public func fetchEvents() {
        let keys = EventlyKeys()
        let clientID = keys.seatGeekClientID
        let clientSecret = keys.seatGeekClientSecret
        let eventUrlString = "\(Constants.seatGeekURL)/events/?client_id=\(clientID)&client_secret=\(clientSecret)"
        performRequest(urlString: eventUrlString)
    }
    
    private func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let events = self.parseJSON(data: safeData) {
                        self.delegate?.didFetchEvents(events)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(data: Data) -> [EventModel]? {
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
            print(error)
            return nil
        }
    }
}
