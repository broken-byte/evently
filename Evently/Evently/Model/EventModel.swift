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
    let timeOfEvent: String
    
    func convertUTCDateTimeToLocal(utcDateTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd"
        // TODO: Finish this method
        return ""
    }
}
