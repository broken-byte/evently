//
//  EventModel.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/13/20.
//

import Foundation

struct EventModel {
    
    let title: String, imageURL, location: String
    var timeOfEvent: String
    
    init(title: String, imageURL: String, location: String, timeOfEvent: String) {
        self.title = title
        self.imageURL = imageURL
        self.location = location
        self.timeOfEvent = timeOfEvent
        self.timeOfEvent = convertUTCDateTimeToLocal(utcDateTime: self.timeOfEvent)
    }
    
    func convertUTCDateTimeToLocal(utcDateTime: String) -> String {
        // TODO: This is still not working, will have to keep tinkering :(
        print(utcDateTime)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var convertedDateString = ""
        if let safeDate = formatter.date(from: utcDateTime) {
            print("can unwrap, heres safedate!")
            print(safeDate)
            formatter.dateFormat = "EEE, d, MMM, yyyy - h:mm a"
            formatter.timeZone = NSTimeZone.local
            convertedDateString = formatter.string(from: safeDate)
        }
        return convertedDateString
    }
}
