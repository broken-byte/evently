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
    var urlSession: URLSessionProtocol!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlSession = URLSession(configuration: .default)
        if let safeEvent = event {
            self.setEventUI(with: safeEvent)
        }
        #warning("I need to use a property injection strategy here")
        /*
         TODO: I need to implement the init(coder:) method since I think
               that's why my view controller's view heirarchy
               isnt loading automatically.
         TODO: I need to move the loading and caching to it's own
               component, since the memory keeps growing which is
               not ok lol
         TODO: I need to find a way to handle my keyboard!
         */
    }
    
    public func setEventUI(with event: EventModel) {
        eventTitleLabel.text = event.title
        eventImageView.loadImage(with: event.imageURL)
        eventDateLabel.text = event.date
        eventTimeLabel.text = event.time
        eventLocationLabel.text = event.location
    }
}
