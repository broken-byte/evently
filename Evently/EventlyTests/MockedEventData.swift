//
//  MockedEventData.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 1/1/21.
//

import Foundation

public final class MockedEventData {
    public static let seatGeekApiJSON: URL = Bundle(for: MockedEventData.self).url(
        forResource: "Resources/seat-geek-api-response-success",
        withExtension: "json")! // TODO Figure out how to mock your json data correctly as this obviously isnt working lol
}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
