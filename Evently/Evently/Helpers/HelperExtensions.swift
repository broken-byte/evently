//
//  HelperExtensions.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/11/21.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(with imageURLString: String, and session: URLSessionProtocol) {
        image = nil
        if let imageFromCache = imageCache.object(forKey: imageURLString as NSString) {
            self.image = imageFromCache
            return
        }
        guard let imageURL = URL(string: imageURLString) else {
            print("Invalid URL Image was passed!")
            return
        }
        let task = session.dataTask(with: imageURL, completion: {(data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let safeDate = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: safeDate) {
                        imageCache.setObject(
                            imageToCache,
                            forKey: imageURLString as NSString
                        )
                        self.image = imageToCache
                    }
                }
            }
            else {
                print("Data from Image URL Retrieval Failed!")
                return
            }
        })
        task.resume()
    }
}
