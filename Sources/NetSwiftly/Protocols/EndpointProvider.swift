//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 29.02.24.
//

import Foundation

public protocol EndpointProvider {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var token: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }
}
