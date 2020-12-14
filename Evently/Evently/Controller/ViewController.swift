//
//  ViewController.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/9/20.
//

import UIKit

class ViewController: UIViewController {
    
    let eventManager = EventManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventManager.fetchEvents()
    }
}

