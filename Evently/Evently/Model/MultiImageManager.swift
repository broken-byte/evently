//
//  MultiImageManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 12/16/20.
//

import Foundation
import UIKit

class MultiImageManager {

    private let session: URLSessionProtocol
    private var fetchedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTaskProtocol]()
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.session = urlSession
    }

    func fetchImage(with url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        // 1
        if let image = fetchedImages[url] {
            completion(.success(image))
            return nil
        }
        // 2
        let uuid = UUID()
        let task = session.dataTask(with: url) { data, response, error in
            // 3
            defer { self.runningRequests.removeValue(forKey: uuid) }
            // 4
            if let data = data, let image = UIImage(data: data) {
                self.fetchedImages[url] = image
                completion(.success(image))
                return
            }
            // 5
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
        // 6
        runningRequests[uuid] = task
        return uuid
    }

    func cancelFetch(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
