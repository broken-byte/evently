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
            self.image = imageFromCache.getRoundedImage(with: Constants.eventImageCornerRadius)
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
            if let safeData = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: safeData) {
                        imageCache.setObject(
                            imageToCache,
                            forKey: imageURLString as NSString
                        )
                        self.image = imageToCache.getRoundedImage(with: Constants.eventImageCornerRadius)
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

//MARK: - UIImage Rounded Image Optimization Getter

extension UIImage {
    func getRoundedImage(with cornerRadius: Double) -> UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: CGFloat(cornerRadius)
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
