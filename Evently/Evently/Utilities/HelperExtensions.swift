//
//  HelperExtensions.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/11/21.
//

import Foundation
import UIKit


//MARK: - UIImage Cache Optimization Extension

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(with imageURLString: String, and session: URLSessionProtocol, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> Void {
        image = nil
        if let imageFromCache = imageCache.object(forKey: imageURLString as NSString) {
            completion(.success(imageFromCache))
            return
        }
        guard let imageURL = URL(string: imageURLString) else {
            let urlError = URLError.invalidInput(imageURLString)
            completion(.failure(urlError))
            return
        }
        let task = session.dataTask(with: imageURL) { data, response, error in
            if let safeData = data, let imageToCache = UIImage(data: safeData) {
                imageCache.setObject(
                    imageToCache,
                    forKey: imageURLString as NSString
                )
                completion(.success(imageToCache))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let badNetworkResponseError = NetworkError.badServerResponse(response)
                completion(.failure(badNetworkResponseError))
                return
            }
        }
        task.resume()
    }
}

//MARK: - Cache Optimization Error Enums

extension UIImageView {
    public enum URLError: Error {
        case invalidInput(_ urlString: String)
    }

    public enum NetworkError: Error {
        case badServerResponse(_ response: URLResponse?)
    }
}

//MARK: - UIImage Rounded Image Optimization Get Function

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
