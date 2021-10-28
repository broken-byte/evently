//
//  EventDetailsViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/23/21.
//

import Foundation
import UIKit

class EventDetailsViewController: UIViewController {
    
    private var event: EventModel
    private var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEventUI()
        /*
         TODO: I need to find a way to handle my keyboard!
         */
    }
    
    init?(coder: NSCoder, event: EventModel, uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol) {
        self.event = event
        self.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
            super.init(coder: coder)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Compatibility iOS 12 and lower
    public func inject(event: EventModel, uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol) {
        self.event = event
        self.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
    }
    
    public func setEventUI() {
        eventTitleLabel.text = event.title
        eventImageView.loadImage(with: event.imageURL, and: uiImageLoadingOrchestrator)
        eventDateLabel.text = event.date
        eventTimeLabel.text = event.time
        eventLocationLabel.text = event.location
    }
}
