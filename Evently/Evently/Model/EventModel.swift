//
//  EventModel.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation

struct EventModel: Equatable {
    
    let title: String
    let imageURL: String
    let location: String
    let date: String
    let time: String
    
    static func == (leftEvent: EventModel, rightEvent: EventModel) -> Bool {
        return
            (leftEvent.title == rightEvent.title) &&
            (leftEvent.imageURL == rightEvent.imageURL) &&
            (leftEvent.location == rightEvent.location) &&
            (leftEvent.date == rightEvent.date) &&
            (leftEvent.time == rightEvent.time)
        }
}
