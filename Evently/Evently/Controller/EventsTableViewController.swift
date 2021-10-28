//
//  ViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/9/20.
//

import UIKit

class EventsTableViewController: UIViewController {
    
    @IBOutlet weak var eventSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var events: [EventModel] = []
    
    public var eventApiManager: EventApiManagerProtocol!
    public var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: Constants.eventCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.eventCellIdentifier
        )

        let dateTimeFormatter = DateTimeFormatter()
        let urlSession = URLSession(configuration: .default)
        let eventApiManager = EventAPIManager(
            urlSession: urlSession,
            dateTimeFormatter: dateTimeFormatter
        )

        let imageLoader = ImageLoader(urlSession: urlSession)
        let uiImageLoadingOrchestrator = UiImageViewLoadingOrchestrator(
            imageLoader: imageLoader,
            dispatchQueue: DispatchQueue.main
        )
        
        self.eventApiManager = eventApiManager
        self.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator

        
        self.eventApiManager.delegate = self
        self.eventApiManager.fetchEvents()
    }
}

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    private var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol?
    
    var onReuse: () -> Void = {}
    
    public func inject(event: EventModel, and uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol) {
        self.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
        setEventUI(with: event)
    }
    
    private func setEventUI(with event: EventModel) {
        eventImage.loadImage(with: event.imageURL, and: uiImageLoadingOrchestrator!)
        eventTitle?.text = event.title
        eventLocation?.text = event.location
        eventDate?.text = event.date
        eventTime?.text = event.time
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        eventImage.image = nil
        guard let safeUIImageLoadingOrchestrator = uiImageLoadingOrchestrator else {
            fatalError("Orchestrator dependency was not injected")
        }
        eventImage.cancelImageLoad(with: safeUIImageLoadingOrchestrator)
    }
    

}

//MARK: - EventManagerDelegate

extension EventsTableViewController: EventManagerDelegate {
    
    func didFetchEvents(_ eventManager: EventAPIManager, fetchedEvents: [EventModel]) {
        events = fetchedEvents
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDataSource

extension EventsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.eventCellIdentifier,
            for: indexPath
        )
            as! EventCell
        cell.inject(
            event: event,
            and: uiImageLoadingOrchestrator
        )
        return cell
    }
}

//MARK: - UITableViewDelegate

extension EventsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let eventAtIndex = events[indexPath.row]
        showEventDetails(given: eventAtIndex)
    }
    
    private func showEventDetails(given event: EventModel) {
        let eventDetailsVC: EventDetailsViewController?
        if #available(iOS 13.0, *) {
            eventDetailsVC = storyboard?.instantiateViewController(
                identifier: Constants.eventDetailsViewControllerIdentifier
            ) { (coder) -> EventDetailsViewController? in
                return EventDetailsViewController(
                    coder: coder,
                    event: event,
                    uiImageLoadingOrchestrator: self.uiImageLoadingOrchestrator
                )
            }
        }
        else {
            eventDetailsVC = storyboard?.instantiateViewController(
                withIdentifier: Constants.eventDetailsViewControllerIdentifier
            ) as? EventDetailsViewController
            eventDetailsVC?.inject(
                event: event,
                uiImageLoadingOrchestrator: self.uiImageLoadingOrchestrator
            )
        }
        guard let eventDetailsVC = eventDetailsVC else {
            fatalError("Unable to Instantiate Event Details View Controller")
        }
        eventDetailsVC.loadViewIfNeeded()
        self.present(
            eventDetailsVC as EventDetailsViewController,
            animated: true,
            completion: nil
        )
    }
}

