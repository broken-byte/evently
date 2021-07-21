//
//  ViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/9/20.
//

import UIKit

class EventViewController: UIViewController {
    
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

extension EventViewController: EventManagerDelegate {
    
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

extension EventViewController: UITableViewDataSource {
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

extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

