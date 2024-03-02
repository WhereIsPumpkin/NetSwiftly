//
//  URLRequestBuilder.swift
//
//  Network Layer Module
//
//  This file contains the definitions and implementations for creating and configuring
//  URL requests for various HTTP methods, handling content types, and extending URL requests
//  with additional functionalities like setting JSON bodies, query items, and authorization tokens.
//
//  Usage Example:
//  The URLRequestBuilder is designed to simplify the creation of URLRequest objects through a fluent API.
//  Here's how you can use it in your projects:
//
//  // Creating a builder with a base URL
//  let builder = URLRequestBuilder(baseURL: URL(string: "https://api.example.com")!)
//
//  // Making a GET request
//  let getRequest = builder.get("/users/\(id)/profile")
//
//  // Making a POST request with a JSON body and custom header
//  var postRequest = builder.post("/users")
//  try postRequest.setJSONBody(profile)
//  postRequest.setValue("1.2.1", forHTTPHeaderField: "X-API-Version")
//
//  // Initializing another builder for a different base URL
//  let otherBuilder = URLRequestBuilder(baseURL: URL(string: "https://api.anotherexample.com")!)
//  let otherRequest = otherBuilder.get("/some/path?param=blah")
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

/// Represents HTTP methods.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Represents content types used in HTTP headers.
public enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}

public class URLRequestBuilder {
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    /// Builds a URL request with the given path, HTTP method, and content type.
    /// - Parameters:
    ///   - path: The endpoint path to be appended to the base URL.
    ///   - method: The HTTP method for the request.
    ///   - contentType: The content type for the request. Defaults to `.json`.
    /// - Returns: A configured URLRequest instance.
    private func buildRequest(path: String, method: HTTPMethod, contentType: ContentType = .json) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    // MARK: - Public Methods for Creating Requests
    
    /// Creates a GET request for the specified path.
    /// - Parameter path: The endpoint path for the HTTP method request.
    /// - Returns: A configured URLRequest instance for a  HTTP method request.
    
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

/// Extensions to URLRequest to add various functionalities.
public extension URLRequest {
    /// Sets the body of the request to a JSON representation of an Encodable object.
    /// - Parameters:
    ///   - body: The Encodable object to encode and set as the request body.
    ///   - encoder: A JSONEncoder to use for encoding the object. Defaults to a new instance of JSONEncoder.
    /// - Throws: An error if encoding fails.
    mutating func setJSONBody<T: Encodable>(_ body: T, encoder: JSONEncoder = JSONEncoder()) throws {
        encoder.dateEncodingStrategy = .iso8601
        self.httpBody = try encoder.encode(body)
    }
    
    /// Adds URL query items to the request.
    /// - Parameter items: A dictionary of query item names and values to add to the request.
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
    
    /// Sets a bearer token for the Authorization header of the request.
    /// - Parameter token: The bearer token to set.
    mutating func setBearerToken(_ token: String) {
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
