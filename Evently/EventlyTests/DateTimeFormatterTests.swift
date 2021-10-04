//
//  DateTimeFormatterTests.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 5/12/21.
//

import XCTest
@testable import Evently

class DateTimeFormatterTests: XCTestCase {
    
    private var dateTimeFormatter: DateTimeFormatter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        dateTimeFormatter = DateTimeFormatter()
    }

    override func tearDownWithError() throws {
        dateTimeFormatter = nil
        try super.tearDownWithError()
    }

    func testThatDateTimeFormatterCanGetFormattedDateTimeGivenUTCDateTime0() throws {
        let expectedDateTime: DateTime = (date: "Wed 12 May 2021", time: "03:30 AM")
        let actualDateTime: DateTime = dateTimeFormatter.getFormattedDateTime(from: "2021-05-12T07:30:00")
        XCTAssertEqual(expectedDateTime.date, actualDateTime.date)
        XCTAssertEqual(expectedDateTime.time, actualDateTime.time)
        
    }
    
    func testThatDateTimeFormatterCanGetFormattedDateTimeGivenUTCDateTime1() throws {
        let expectedDateTime: DateTime = (date: "Wed 12 May 2021", time: "06:30 AM")
        let actualDateTime: DateTime = dateTimeFormatter.getFormattedDateTime(from: "2021-05-12T10:30:00")
        XCTAssertEqual(expectedDateTime.date, actualDateTime.date)
        XCTAssertEqual(expectedDateTime.time, actualDateTime.time)
        
    }
    
    func testThatDateTimeFormatterCanGetFormattedDateTimeGivenUTCDateTime2() throws {
        let expectedDateTime: DateTime = (date: "Wed 12 May 2021", time: "13:00 PM")
        let actualDateTime: DateTime = dateTimeFormatter.getFormattedDateTime(from: "2021-05-12T17:00:00")
        XCTAssertEqual(expectedDateTime.date, actualDateTime.date)
        XCTAssertEqual(expectedDateTime.time, actualDateTime.time)
        
    }
}
