//
//  EventDetailsViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/23/21.
//

import Foundation
import UIKit

class EventDetailsViewController: UIViewController {
    
    private var event: EventModel?
    private var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol?
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEventUI()
    }
    
    public func injectDependencies(event: EventModel, uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol) {
        self.event = event
        self.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
    }
    
    private func setEventUI() {
        guard let safeOrchestrator = uiImageLoadingOrchestrator, let safeEvent = event else {
            fatalError("Dependencies were not injected into View Controller prior to loading")
        }
        eventTitleLabel.text = safeEvent.title
        eventImageView.loadImage(with: safeEvent.imageURL, and: safeOrchestrator)
        eventDateLabel.text = safeEvent.date
        eventTimeLabel.text = safeEvent.time
        eventLocationLabel.text = safeEvent.location
    }
}
