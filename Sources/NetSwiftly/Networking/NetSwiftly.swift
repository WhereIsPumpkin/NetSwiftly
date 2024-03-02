// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 13.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    public var debugEnabled: Bool = false
    private let urlSession: URLSession
    private var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    
    private init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func setDateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy) {
        self.dateDecodingStrategy = strategy
    }
    
    public func performRequest<T: Decodable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        guard let url = request.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            if let decodedError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw NetworkError.serverMessage(decodedError.message)
            } else {
                throw NetworkError.requestFailed
            }
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    
}

@available(iOS 13.0.0, *)
extension NetSwiftly {
    private func log(_ message: String) {
        if debugEnabled {
            print(message)
        }
    }
}
