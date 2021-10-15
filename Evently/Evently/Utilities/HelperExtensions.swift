//
//  HelperExtensions.swift
//  Evently
//
//  Created by Ricardo Carrillo on 7/11/21.
//

import Foundation
import UIKit

//MARK: - Image Loading Extensions

extension UIImageView {
    func loadImage(with imageUrlString: String, and imageLoadingHandler: UIImageViewLoadingOrchestratorProtocol) {
        imageLoadingHandler.load(with: imageUrlString, for: self)
    }

    func cancelImageLoad(with imageLoadingHandler: UIImageViewLoadingOrchestratorProtocol) {
        imageLoadingHandler.cancel(for: self)
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
