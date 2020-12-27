//
//  EventManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation
import Keys

struct EventManager {
    
    func fetchEvents() {
        let keys = EventlyKeys()
        let clientID = keys.seatGeekClientID
        let clientSecret = keys.seatGeekClientSecret
        let eventUrlString = "\(Constants.seatGeekURL)/events/?client_id=\(clientID)&client_secret=\(clientSecret)"
        performRequest(urlString: eventUrlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(data: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) {
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
                print(event.timeOfEventInLocalFormat)
            }
            print(events)
        }
        catch {
            print(error)
        }
    }
}
