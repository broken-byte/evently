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
    
    var events: [EventModel] = []
    var dateTimeFormatter: DateTimeFormatter!
    var urlSession: URLSessionProtocol!
    var eventManager: EventAPIManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: Constants.eventCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.eventCellIdentifier
        )
        
        dateTimeFormatter = DateTimeFormatter()
        urlSession = URLSession(configuration: .default)
        eventManager = EventAPIManager(urlSession: urlSession, dateTimeFormatter: dateTimeFormatter)
        eventManager.delegate = self
        eventManager.fetchEvents()
    }
}

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
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
        eventImage.cancelImageLoad()
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
        cell.eventImage.loadImage(with: event.imageURL)
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
        eventDetailsViewController.loadViewIfNeeded()
        self.present(eventDetailsViewController as EventDetailsViewController, animated: true, completion: nil)
        
    }
}

