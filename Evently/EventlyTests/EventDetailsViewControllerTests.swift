//
//  EventDetailsViewControllerTests.swift
//  EventlyTests
//
//  Created by Ricardo Carrillo on 10/30/21.
//

import Foundation
import UIKit
import XCTest
@testable import Evently

class EventDetailsViewControllerTests: XCTestCase {
    
    private var mockOrchestrator: MockOrchestrator!
    private var mockEvent: EventModel!
    private var eventDetailsVC: EventDetailsViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockOrchestrator = MockOrchestrator()
        mockEvent = EventModel(
            title: "Folds of Honor QuikTrip 500",
            imageURL: "https://seatgeek.com/images/performers-landscape/folds-of-honor-quiktrip-500-1-4c93a3/622294/huge.jpg",
            location: "Hampton, GA",
            date: "Wed 12 May 2021",
            time: "03:30 AM"
        )
        eventDetailsVC = makeEventDetailsViewController()
    }
    
    func makeEventDetailsViewController() -> EventDetailsViewController {
        let storyboard = UIStoryboard(name: Constants.mainStoryBoardIdentifier, bundle: nil)
        let eventDetailsVC = storyboard.instantiateViewController(
            withIdentifier: Constants.eventDetailsViewControllerIdentifier
        ) as! EventDetailsViewController
        
        return eventDetailsVC
    }
    
    override func tearDownWithError() throws {
        mockOrchestrator = nil
        mockEvent = nil
        eventDetailsVC = nil
        try super.tearDownWithError()
    }
    
    func testThatVcSetsContentCorrectlyWhenOrchestratorLoadsSuccessfully() throws {
        mockOrchestrator.shouldLoadSuccessfully = true
        eventDetailsVC.injectDependencies(event: mockEvent, uiImageLoadingOrchestrator: mockOrchestrator)
        eventDetailsVC.loadViewIfNeeded()
        XCTAssertEqual(eventDetailsVC.eventTitleLabel.text, mockEvent.title)
        XCTAssertNotNil(eventDetailsVC.eventImageView.image)
        XCTAssertEqual(eventDetailsVC.eventLocationLabel.text, mockEvent.location)
        XCTAssertEqual(eventDetailsVC.eventDateLabel.text, mockEvent.date)
        XCTAssertEqual(eventDetailsVC.eventTimeLabel.text, mockEvent.time)
    }
    
    func testThatVcSetsContentCorrectlyWhenOrchestratorDoesntLoad() throws {
        mockOrchestrator.shouldLoadSuccessfully = false
        eventDetailsVC.injectDependencies(event: mockEvent, uiImageLoadingOrchestrator: mockOrchestrator)
        eventDetailsVC.loadViewIfNeeded()
        XCTAssertEqual(eventDetailsVC.eventTitleLabel.text, mockEvent.title)
        XCTAssertNotNil(eventDetailsVC.eventImageView.image!)
        XCTAssertEqual(eventDetailsVC.eventLocationLabel.text, mockEvent.location)
        XCTAssertEqual(eventDetailsVC.eventDateLabel.text, mockEvent.date)
        XCTAssertEqual(eventDetailsVC.eventTimeLabel.text, mockEvent.time)
    }
}
