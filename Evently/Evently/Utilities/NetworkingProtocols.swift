//
//  NetworkingProtocols.swift
//  Evently
//
//  Created by Ricardo Carrillo on 1/15/21.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)-> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completion) as URLSessionDataTaskProtocol
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { } // Avoids typing errors
