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
    
    private var eventApiManager: EventApiManagerProtocol!
    private var events: [EventModel] = []
    private var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol!
    
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
        let imageLoader = ImageLoader(urlSession: urlSession)
        
        eventApiManager = EventAPIManager(urlSession: urlSession, dateTimeFormatter: dateTimeFormatter)
        eventApiManager.delegate = self
        uiImageLoadingOrchestrator = UiImageViewLoadingOrchestrator(imageLoader: imageLoader, dispatchQueue: DispatchQueue.main)
        eventApiManager.fetchEvents()
    }
}

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol!
    
    var onReuse: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        #warning("I need to set up a property injection strategy here")
    }
    
    override func prepareForReuse() {
        eventImage.image = nil
        eventImage.cancelImageLoad(with: uiImageLoadingOrchestrator)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventCellIdentifier, for: indexPath)
            as! EventCell
        cell.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
        cell.eventImage.loadImage(with: event.imageURL, and: uiImageLoadingOrchestrator)
        cell.eventTitle?.text = event.title
        cell.eventLocation?.text = event.location
        cell.eventDate?.text = event.date
        cell.eventTime?.text = event.time
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
        guard let eventDetailsViewController = storyboard?.instantiateViewController(
                withIdentifier: Constants.eventDetailsViewControllerIdentifier) as? EventDetailsViewController
        else {
            fatalError("Unable to Instantiate Event Details View Controller")
        }
        eventDetailsViewController.event = event
        eventDetailsViewController.uiImageLoadingOrchestrator = uiImageLoadingOrchestrator
        eventDetailsViewController.loadViewIfNeeded()
        self.present(eventDetailsViewController as EventDetailsViewController, animated: true, completion: nil)
    }
}

