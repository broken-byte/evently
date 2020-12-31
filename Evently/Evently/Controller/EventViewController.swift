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
    
    var eventManager = EventManager()
    var events: [EventModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        eventManager.delegate = self
        eventManager.fetchEvents()
    }
}

//MARK: - EventManagerDelegate

extension EventViewController: EventManagerDelegate {
    
    func didFetchEvents(_ eventManager: EventManager, fetchedEvents: [EventModel]) {
        self.events = fetchedEvents
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.events[indexPath.row].title
        return cell
    }
}

//MARK: - UITableViewDelegate

extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

