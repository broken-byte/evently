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
    var eventManager: EventAPIManager!
    var urlSession: URLSessionProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: Constants.eventCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.eventCellIdentifier
        )

        urlSession = URLSession(configuration: .default)
        let dateTimeFormatter = DateTimeFormatter()
        eventManager = EventAPIManager(urlSession: urlSession, dateTimeFormatter: dateTimeFormatter)
        eventManager.delegate = self
        eventManager.fetchEvents()
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
        cell.eventImage?.loadImage(with: event.imageURL, and: urlSession) { result in
            do {
                let loadedImage = try result.get()
                DispatchQueue.main.async {
                    cell.eventImage.image = loadedImage.getRoundedImage(with: Constants.eventImageCornerRadius)
                }
            } catch {
                print(error)
            }
        }
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
        let eventAtIndex = events[indexPath.row]
        #warning("Haven't figured out how to get this to work yet lol")
        //showEventDetails(given: eventAtIndex)
    }
    
    private func showEventDetails(given event: EventModel) {
//        guard let eventDetailsViewController = UIStoryboard(name: "Main", bundle: .main)
//                .instantiateViewController(withIdentifier: "EventDetailsViewController")
//                as? EventDetailsViewController else {
//            fatalError("Unable to Instantiate Event Details View Controller")
//        }
        let eventDetailsViewController = EventDetailsViewController()
        present(eventDetailsViewController, animated: true, completion: nil)
    }
}
