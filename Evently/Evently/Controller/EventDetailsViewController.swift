//
//  EventDetailsViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/23/21.
//

import Foundation
import UIKit

class EventDetailsViewController: UIViewController {
    
    var event: EventModel?
    var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol?
    var urlSession: URLSessionProtocol!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlSession = URLSession(configuration: .default)
        if let safeEvent = event, let safeOrchestrator = uiImageLoadingOrchestrator {
            self.setEventUI(with: safeEvent, and: safeOrchestrator)
        }
        #warning("I need to use a property injection strategy here")
        /*
         TODO: I need to implement the init(coder:) method for dependency injection
         TODO: I need to find a way to handle my keyboard!
         */
    }
    
    public func setEventUI(with event: EventModel, and uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol) {
        eventTitleLabel.text = event.title
        eventImageView.loadImage(with: event.imageURL, and: uiImageLoadingOrchestrator)
        eventDateLabel.text = event.date
        eventTimeLabel.text = event.time
        eventLocationLabel.text = event.location
    }
}
