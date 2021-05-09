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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: Constants.eventCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.eventCellIdentifier
        )
        
        let urlSession = URLSession(configuration: .default)
        var eventManager = EventManager(urlSession: urlSession)
        eventManager.delegate = self
        eventManager.fetchEvents()
    }
}

//MARK: - EventManagerDelegate

extension EventViewController: EventManagerDelegate {
    
    func didFetchEvents(_ eventManager: EventManager, fetchedEvents: [EventModel]) {
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
        #warning("TODO: Omitted image url since still need to implement the MultiImageManager for caching/async of image url")
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

