//
//  File.swift
//
//
//  Created by Saba Gogrichiani on 29.02.24.
//

import Foundation

public extension EndpointProvider {
    var scheme: String { "https" }
    var token: String? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: [String: Any]? { nil }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: "\(scheme)://\(baseURL)\(path)") else {
            throw ApiError(errorCode: "URL_CONSTRUCTION_FAILURE", message: "Unable to construct the URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Body
        if let body = body, let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) {
            urlRequest.httpBody = httpBody
        }
        
        // Query Items
        if let queryItems = queryItems, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
        
        return urlRequest
    }
}
