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
            setEventUI(with: safeEvent)
        }
        #warning("I need to use a property injection strategy here")
    }
    
    private func setEventUI(with event: EventModel) {
        eventTitleLabel.text = event.title
        eventImageView.loadImage(with: event.imageURL, and: urlSession) { result in
            do {
                let loadedImage = try result.get()
                DispatchQueue.main.async {
                    self.eventImageView.image = loadedImage.getRoundedImage(with: Constants.eventImageCornerRadius)
                }
            } catch {
                print(error)
            }
        }
        eventDateLabel.text = event.date
        eventTimeLabel.text = event.time
        eventLocationLabel.text = event.location
    }
}
