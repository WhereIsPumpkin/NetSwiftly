// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 13.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    private init() {}
    
    public func fetchData<T: Decodable>(from urlRequest: URLRequest, decodeTo type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
    
}
