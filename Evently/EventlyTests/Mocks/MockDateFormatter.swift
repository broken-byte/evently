//
//  MockDateFormatter.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 5/12/21.
//

import Foundation
@testable import Evently

struct MockDateFormatter: DateTimeFormatterProtocol {
    func getFormattedDateTime(from dateTimeInUTC: String) -> DateTime {
        return (date: "Wed 12 May 2021", time: "03:30 AM")
    }
}
