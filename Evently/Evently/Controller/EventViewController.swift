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
    var events: [EventModel] = [
        EventModel(
            title: "Disney On Ice Dream Big - Hidalgo",
            imageURL: "https://seatgeek.com/images/performers-landscape/disney-on-ice-dream-big-9e1ba1/576406/huge.jpg",
            location: "Hidalgo, TX",
            timeOfEventInUTC: "2020-12-27T17:30:00"
        ),
        EventModel(
            title: "Disney On Ice Dream Big - Hidalgo",
            imageURL: "https://seatgeek.com/images/performers-landscape/disney-on-ice-dream-big-9e1ba1/576406/huge.jpg",
            location: "Hidalgo, TX",
            timeOfEventInUTC: "2020-12-27T17:30:00"
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCellIdentifier, for: indexPath)
        cell.textLabel?.text = "This is a cell"
        return cell
    }
}

