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
        eventManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        eventManager.fetchEvents()
    }
}

//MARK: - EventManagerDelegate

extension EventViewController: EventManagerDelegate {
    func didFetchEvents(_ fetchedEvents: [EventModel]) {
        print(fetchedEvents)
    }
}

//MARK: - UITableViewDataSource

extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Still not working grrrrr"
        return cell
    }
}

//MARK: - UITableViewDelegate

extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

