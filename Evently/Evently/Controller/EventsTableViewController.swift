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
    
    private var events = [EventModel]()
    
    public var eventApiManager: EventApiManagerProtocol!
    public var uiImageLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlSession = URLSession(configuration: .default)
        eventApiManager = createEventApiManager(with: urlSession)
        uiImageLoadingOrchestrator = createOrchestrator(with: urlSession)
        
        eventSearchBar.delegate = self
        tableView.delegate = self
        eventApiManager.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: Constants.eventCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.eventCellIdentifier
        )
        eventApiManager.fetchEvents()
    }
    
    private func createEventApiManager(with urlSession: URLSessionProtocol) -> EventApiManagerProtocol {
        let dateTimeFormatter = DateTimeFormatter()
        return EventAPIManager(
            urlSession: urlSession,
            dateTimeFormatter: dateTimeFormatter
        )
    }
    
    private func createOrchestrator(with urlSession: URLSessionProtocol) -> UiImageViewLoadingOrchestratorProtocol {
        let imageLoader = ImageLoader(urlSession: urlSession)
        return UiImageViewLoadingOrchestrator(
            imageLoader: imageLoader,
            dispatchQueue: DispatchQueue.main
        )
    }
}

//MARK: - Search

extension EventsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        eventApiManager.fetchEvents(searchQuery: searchText)
    }
         
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(false)
    }
}


//MARK: - EventCell

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
    
    private func setEventUI(with event: EventModel?) {
        guard let safeEvent = event, let safeOrchestrator = uiImageLoadingOrchestrator else {
           fatalError("EventCell dependencies were not injected")
        }
        eventImage.loadImage(with: safeEvent.imageURL, and: safeOrchestrator)
        eventTitle?.text = safeEvent.title
        eventLocation?.text = safeEvent.location
        eventDate?.text = safeEvent.date
        eventTime?.text = safeEvent.time
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.eventCellIdentifier,
            for: indexPath
        ) as! EventCell
        let event: EventModel = events[indexPath.row]
        cell.inject(event: event, and: uiImageLoadingOrchestrator)
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
        guard let safeEventDetailsVC = storyboard?.instantiateViewController(
            withIdentifier: Constants.eventDetailsViewControllerIdentifier
        ) as? EventDetailsViewController else {
            fatalError("Unable to Instantiate Event Details View Controller")
        }
        safeEventDetailsVC.injectDependencies(
            event: event,
            uiImageLoadingOrchestrator: self.uiImageLoadingOrchestrator
        )
        safeEventDetailsVC.loadViewIfNeeded()
        self.present(
            safeEventDetailsVC as EventDetailsViewController,
            animated: true,
            completion: nil
        )
    }
}

