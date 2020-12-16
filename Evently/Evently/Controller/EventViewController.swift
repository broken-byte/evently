//
//  ViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/9/20.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventSearchBar: UISearchBar!
    let eventManager = EventManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventManager.fetchEvents()
    }
}

