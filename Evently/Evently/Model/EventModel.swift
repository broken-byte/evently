//
//  EventModel.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation

struct EventModel {
    
    let title: String
    let imageURL: String
    let location: String
    var timeOfEventInUTC: String
    
    public func getTimeOfEventInLocalFormat() -> String { // TODO: Get the datetime to appeat in 12 hour format instead of 24 hour
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        guard let utcDate = dateFormatter.date(from: timeOfEventInUTC) else {
            assertionFailure(
                "Failed to create Date object from ISO UTC date string"
            )
            return ""
        }
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy\nHH:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeOfEventInLocalFormat: String = dateFormatter.string(from: utcDate)
        return timeOfEventInLocalFormat
    }
}
