//
//  CachedImageLoadingManager.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/29/21.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    
    func loadImage(with imageUrlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
    
    func cancelLoad(_ uuid: UUID)
}

class ImageLoader: ImageLoaderProtocol {
    
    private var loadedImagesCache = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTaskProtocol]()
    private var session: URLSessionProtocol!
    
    init(urlSession: URLSessionProtocol) {
        session = urlSession
    }
    
    public func loadImage(with imageUrlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        guard let imageURL = URL(string: imageUrlString) else {
            let urlError = URLError.invalidInput(imageUrlString)
            completion(.failure(urlError))
            return nil
        }
        if let image = loadedImagesCache[imageURL] {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()

        let task = session.dataTask(with: imageURL) { data, response, error in
            defer {
                self.runningRequests.removeValue(forKey: uuid)
                
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let badNetworkResponseError = NetworkError.badServerResponse(response)
                completion(.failure(badNetworkResponseError))
                return
            }
            if let safeData = data, let image = UIImage(data: safeData) {
                self.loadedImagesCache[imageURL] = image
                completion(.success(image))
                return
            }

            guard let error = error, (error as NSError).code == NSURLErrorCancelled else {
                let unknownDataTaskError = DataTaskError.unknownError(imageUrlString)
                completion(.failure(unknownDataTaskError))
                return
            }
        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }
    
    public func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}

//MARK: - Error Enumerations

extension ImageLoader {
    public enum URLError: Error {
        case invalidInput(_ urlString: String)
    }

    public enum NetworkError: Error {
        case badServerResponse(_ response: URLResponse?)
    }
    
    public enum DataTaskError: Error {
        case unknownError(_ imageURLString: String)
    }
}
