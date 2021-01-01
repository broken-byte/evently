//
//  EventImageManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/16/20.
//

import Foundation
import UIKit

class MultiImageManager {
    
    private var fetchedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]() 
    
    func fetchImage(with url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
      if let image = fetchedImages[url] {
        completion(.success(image))
        return nil
      }
      let uuid = UUID()
      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        defer { self.runningRequests.removeValue(forKey: uuid) }
        if let data = data, let image = UIImage(data: data) {
          self.fetchedImages[url] = image
          completion(.success(image))
          return
        }
        guard let error = error else {
          print("Image Manager failed with a nil error!")
          return
        }
        guard (error as NSError).code == NSURLErrorCancelled else {
          completion(.failure(error))
            // Throw the error up the call stack if it failed but wasn't cancelled.
          return
        }
      }
      task.resume()
      runningRequests[uuid] = task
      return uuid
    }
    
    func cancelFetch(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
}
