//
//  UIImageLoadingHandler.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/30/21.
//

import Foundation
import UIKit

protocol UiImageViewLoadingOrchestratorProtocol {
    
    func load(with imageUrlString: String, for imageView: UIImageView)
    
    func cancel(for imageView: UIImageView)
}

class UiImageViewLoadingOrchestrator: UiImageViewLoadingOrchestratorProtocol {
    
    private let loader: ImageLoaderProtocol
    private let mainDispatchQueue: DispatchQueueProtocol
    private var uuidMap = [UIImageView: UUID]()
    
    init(imageLoader: ImageLoaderProtocol, dispatchQueue: DispatchQueueProtocol) {
        self.loader = imageLoader
        self.mainDispatchQueue = dispatchQueue
    }
    
    func load(with imageUrlString: String, for imageView: UIImageView) {
        let token: UUID? = loader.loadImage(with: imageUrlString) { result in
            defer {
                self.uuidMap.removeValue(forKey: imageView)
            }
            do {
                let loadedImage = try result.get()
                self.mainDispatchQueue.async {
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

//MARK: - DispatchQueue Dependency Injection BoilerPlate

protocol DispatchQueueProtocol {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueProtocol {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

