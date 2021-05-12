//
//  DateTimeFormatter.swift
//  Evently
//
//  Created by Ricardo Carrillo on 5/12/21.
//

import Foundation

typealias DateTime = (date: String, time: String)

protocol DateTimeFormatterProtocol {
    
    func getFormattedDateTime(from dateTimeInUTC: String) -> DateTime
}

struct DateTimeFormatter: DateTimeFormatterProtocol {
    
    public func getFormattedDateTime(from dateTimeInUTC: String) -> DateTime {
        let formatter = DateFormatter()
        configureFormatterForIngestion(formatter)
        guard let utcDateTime: Date = formatter.date(from: dateTimeInUTC) else {
            assertionFailure("Failed to create Date object from ISO UTC date string")
            return (date: "", time: "")
        }
        configureFormatterForConversion(formatter)
        return getDateTime(with: formatter, and: utcDateTime)
    }
    
    private func configureFormatterForIngestion(_ formatter: DateFormatter) {
        formatter.dateFormat = Constants.apiUTCDateTimeFormat
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        formatter.locale = Locale(identifier: Constants.dateFormatterLocaleID)
    }
    
    private func configureFormatterForConversion(_ formatter: DateFormatter) {
        formatter.dateFormat = Constants.eventDateTimeFormat
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = TimeZone.current
    }
    
    private func getDateTime(with formatter: DateFormatter, and utcDateTime: Date) -> DateTime {
        let dateTimeComponents: [String] = formatter
            .string(from: utcDateTime)
            .components(separatedBy: ", ")
        let dateTime: DateTime = (date: dateTimeComponents[1], time: dateTimeComponents[0])
        return dateTime
    }
}
