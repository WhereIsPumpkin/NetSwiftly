//
//  File.swift
//
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}

public class URLRequestBuilder {
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    private func buildRequest(path: String, method: HTTPMethod, contentType: ContentType = .json) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func get(_ path: String) -> URLRequest {
        return buildRequest(path: path, method: .get)
    }
    
    public func post(_ path: String) -> URLRequest {
        return buildRequest(path: path, method: .post)
    }
    
    public func put(_ path: String) -> URLRequest {
        return buildRequest(path: path, method: .put)
    }
    
    public func patch(_ path: String) -> URLRequest {
        return buildRequest(path: path, method: .patch)
    }
    
    public func delete(_ path: String) -> URLRequest {
        return buildRequest(path: path, method: .delete)
    }
}

extension URLRequest {
    mutating func setJSONBody<T: Encodable>(_ body: T, encoder: JSONEncoder = JSONEncoder()) throws {
        encoder.dateEncodingStrategy = .iso8601
        self.httpBody = try encoder.encode(body)
    }
    
    mutating func addQueryItems(_ items: [String: String]) {
        guard var urlComponents = URLComponents(url: self.url!, resolvingAgainstBaseURL: false) else { return }
        
        let queryItems = items.map { URLQueryItem(name: $0.key, value: $0.value) }
        if urlComponents.queryItems != nil {
            urlComponents.queryItems!.append(contentsOf: queryItems)
        } else {
            urlComponents.queryItems = queryItems
        }
        
        self.url = urlComponents.url
    }
    
    mutating func setBearerToken(_ token: String) {
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
