//
//  EventImageManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/16/20.
//

import Foundation

struct ImageManager { // TODO: Figure out how to get the Image data from the image url
    
    func fetchImage(with imageUrl: String) {
        return performRequest(urlString: imageUrl)
    }
    
    private func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    // self.parseJSON(data: safeData)
                }
            }
            task.resume()
        }
    }
    
}
    
