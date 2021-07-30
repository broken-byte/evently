//
//  UIImageLoadingHandler.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/30/21.
//

import Foundation
import UIKit

class UIImageLoadingHandler {
    // Singleton
    static let loader = UIImageLoadingHandler()
    static let urlSession: URLSessionProtocol = URLSession(configuration: .default)
    private let imageLoadingManager = ImageLoadingManager(urlSession: urlSession)
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(with imageUrlString: String, for imageView: UIImageView) {
        let token = imageLoadingManager.loadImage(with: imageUrlString) { result in
            defer {
                self.uuidMap.removeValue(forKey: imageView)
            }
            do {
                let loadedImage = try result.get()
                DispatchQueue.main.async {
                    imageView.image = loadedImage.getRoundedImage(with: Constants.eventImageCornerRadius)
                }
            }
            catch {
                imageView.image = #imageLiteral(resourceName: "DefaultEventImage")  // default image
                print(error)
            }
        }
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoadingManager.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
    
}
