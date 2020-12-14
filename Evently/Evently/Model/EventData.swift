//
//  Events.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation

struct EventData: Decodable {
    let events: [Event]
}

struct Event: Decodable {
    let title: String
    let performers: [Performer]
    let venue: Venue
    let datetime_utc: String
}

struct Performer: Decodable {
    let image: String
}

struct Venue: Decodable {
    let display_location: String
}
