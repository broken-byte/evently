//
//  UIImageLoadingHandler.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/30/21.
//

import Foundation
import UIKit

protocol UIImageViewLoadingOrchestratorProtocol {
    
    func load(with imageUrlString: String, for imageView: UIImageView)
    
    func cancel(for imageView: UIImageView)
}

class UIImageViewLoadingOrchestrator: UIImageViewLoadingOrchestratorProtocol {
    
    private let loader: ImageLoaderProtocol
    private var uuidMap = [UIImageView: UUID]()
    
    init(imageLoadingManager: ImageLoaderProtocol) {
        self.loader = imageLoadingManager
    }
    
    func load(with imageUrlString: String, for imageView: UIImageView) {
        let token = loader.loadImage(with: imageUrlString) { result in
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
            loader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
    
}
